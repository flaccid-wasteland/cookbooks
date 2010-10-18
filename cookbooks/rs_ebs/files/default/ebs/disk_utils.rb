module RightScale
  require 'fileutils'

  class DiskUtils
    attr_accessor :frozen, :device, :mount_point
 
    def initialize(mount_point, device=nil)
      @mount_point = mount_point
      if device
        @device = device
      elsif self.get_device_from_fstab
        @device = self.get_device_from_fstab
      else
        @device = "/dev/vg-ebs-rightscale/lvol0"
      end
      @frozen = false
    end 

    def disable_volume
      lvchange("-an")
    end

    def enable_volume
      pvscan
      lvchange("-ay")
    end

    def initialize_stripe(devices)
# pvcreate x volumes
      @pv_devices = devices
      @pv_devices.each do |d|
        self.pvcreate(d)
      end
      self.vgcreate
      self.lvcreate
      self.mkfs_xfs!
      self.mount
      self.write_fstab
    end

    def write_fstab
      FileUtils.cp("/etc/fstab", "/etc/fstab.bak")
      fstab = File.readlines("/etc/fstab")
      File.open("/etc/fstab", "w") do |f|
        fstab.each do |line|
          if line.include?(@mount_point)
            STDERR.puts "WARNING: detected mount point already in fstab, removing fstab entry for #{line}"
          else
            f.puts(line)  
          end
        end
        fstab_entry = "#{@device}\t#{@mount_point}\txfs\tdefaults,noatime 0 0"
        STDERR.puts "ADDING DEVICE /etc/fstab: #{fstab_entry}"
        f.puts(fstab_entry)
      end
    end

    def pvscan
      execute("pvscan")
    end

    def pvcreate(device)
      execute("pvcreate -yf #{device}")
    end

    def vgcreate
      execute("vgcreate #{self.vgname} #{@pv_devices.join(" ")}")
    end

    def lvname
      if @device.nil?
        return "lvol0"
      else
        return @device.split(/\//).last
      end
    end

    def generate_physical_device_names(count)
      devrange = ('k' .. 'x').to_a
      devices = []
      count.times do |device_gen|
        devices << "/dev/sd#{devrange[device_gen]}"  
      end
      return devices
    end

# uses mount_point to grab device out of /etc/fstab
    def get_device_from_fstab(mount_point = @mount_point, fstab_path = "/etc/fstab")
      fstab = IO.readlines(fstab_path)
      fstab.each do |entry|
        dev, mp, _, _ = entry.split(/[\t\s]/)
        return dev if mp == mount_point
      end
      nil
    end

    def get_physical_device_names
# use volume-group name to detect 'physical' device names
      pvs = `pvdisplay -c`
      pvs.collect do |d| 
        pd, vg, _ = d.split(/:/)
        pd.gsub!(/^\s+/,"")
        pd if vg == self.vgname
      end.reject { |s| s.nil? } 
    end

    def vgname
      # we might be creating from scratch and with no device
      if @device.nil?
        return "vg-ebs-rightscale"
      else
        _, _, vg, _ = @device.split(/\//)
      end
      vg
    end

    def lvcreate(flags_override = nil)
      #-I == stripe size (should try to match db blocksize)
      
      flags_override.nil? ? flags = "#{self.vgname} -n #{self.lvname} -i #{@pv_devices.size} -I 256 -l 100%VG " : flags = flags_override
      execute("lvcreate #{flags}") 
      @device = "/dev/#{self.vgname}/#{self.lvname}"
    end

    def mkfs_xfs!
      execute("mkfs.xfs #{@device}")
    end

    def lvchange(flags)
      command = "lvchange #{flags} #{@device}"
      STDERR.puts "executing #{command}"
      STDERR.puts `#{command}`
      STDERR.puts "WARNING: #{command} exited with non-zero status" unless $?.success?
    end

    def sync
      STDERR.puts "syncing filesystem.."
      STDERR.puts `sync`
      STDERR.puts "Filesystem synched."
    end

    def freeze(retry_num = 3)
      freeze_cmd = "xfs_freeze -f #{@mount_point}"
      success = execute(freeze_cmd, :retry_num => retry_num)
      @frozen = success
    end

    def unfreeze(retry_num = 3)
      unfreeze_cmd = "xfs_freeze -u #{@mount_point}"
      success = execute(unfreeze_cmd, :retry_num => retry_num)
      @frozen = !success
      success
    end

    def execute(command, options = {})

      retry_num = options[:retry_num] ? options[:retry_num] : 0
      retry_sleep = options[:retry_sleep] ? options[:retry_sleep] : 60
      ignore_failure = options[:ignore_failure] ? options[:ignore_failure] : false

      (retry_num + 1).times do |attempt|
        STDERR.puts "running #{command}"
        output = `#{command}`
        STDERR.puts output
        return true if $?.success?
        sleep retry_sleep unless retry_num == 0
      end
      raise "ERROR: failed to run #{command}." unless ignore_failure
      false
    end

    def umount
      STDERR.puts "attempting to umount #{@mount_point}"
      STDERR.puts `umount #{@mount_point}`
      if $?.success?
        STDERR.puts "successfully umounted #{@mount_point}"
      elsif File.exists?(@mount_point)
        STDERR.puts "WARNING: failure to umount filesystem #{@mount_point}"
      else
        STDERR.puts "WARNING: failure to umount filesystem #{@mount_point} does not exist!"
      end
    end

    def mount
      FileUtils.mkdir_p(@mount_point) unless File.exists?(@mount_point)
      command = "mount -o noatime #{@device} #{@mount_point}"
      success = execute(command, :ignore_failure => true)
      @mounted = success
    end
    
  end
end
