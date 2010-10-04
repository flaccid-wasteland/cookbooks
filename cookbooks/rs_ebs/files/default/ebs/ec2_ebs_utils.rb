# Common class for EBS based backups/restores

require 'rubygems'
require 'rest_client'
require 'cgi'
require 'json'

class RestClient::Request                                                         
  alias_method :orig_default_headers, :default_headers

  def default_headers
    headers = orig_default_headers
    headers[:accept_encoding] = nil
    headers                             
  end                                                                                                         
end
 
module RightScale
  # Just some convenience exception container for remote execution errors
  class EBSRemoteExecException < RuntimeError
    attr :exit_code, :message
    def initialize(remote_host, exit_code, message)
      @host = remote_host || "localhost"
      @exit_code = exit_code
      @message = message
    end
  
    def to_s
      return "Host:#@host Error:#@exit_code\n#@message"
    end
  end



  class Ec2EbsUtils 
    attr_reader :MountPoint
    def initialize(params)
      @MountPoint = params[:mount_point]
      @api_url = params[:rs_api_url]
      @api_snap_timeout=10 #Let's wait a max of 10 secs for a snapshot call to finish...and bail out if it doesn't happen.
      raise "Invalid RightScale API URL!" unless @api_url
    end
    
    def last_snapshot(nickname)
      # Find the last snapshot of that nickname prefix
      params = {:prefix => nickname,:api_version => 1.0}
      STDERR.puts "Requesting the latest snapshot from the RightScale API"
      #STDERR.puts "HERE IS THE URL: #{@api_url+"/find_latest_ebs_snapshot.js"+"?"+requestify(params)}"
      body = RestClient.get @api_url+"/find_latest_ebs_snapshot.js"+"?"+requestify(params)
      #STDERR.puts "HERE IS THE RESPONSE [#{body}]"
      json = body.nil? ? nil: JSON.load(body)
      json
    rescue => e
      STDERR.puts "#{e.response.body}"
    end

    # Options: suffix, description, tag, max_snapshots, prefix_override (if we want to use a prefix different than the volume name)
    def create_snapshot(device, options = {})
      # TODO - add in new param commit=explicit once the API is availible
      params = {:device => device, 
        :suffix => options[:suffix], 
        :description => options[:description], 
        :tag => options[:tag],
        :max_snaps => options[:max_snaps],
        :prefix_override => options[:prefix_override],
        :commit => "explicit",
        :api_version => 1.0}
      # Perform API call to snapshot the volume attached to the device on the instance
      STDERR.puts "Performing RightScale API call to create a new snapshot"
      #STDERR.puts "HERE IS THE URL: #{@api_url}/create_ebs_snapshot.js (PARAMS: #{params.inspect})"
      json=nil
      Terminator.terminate(@api_snap_timeout) do
        body = RestClient.post @api_url+"/create_ebs_snapshot.js",params
        json = body.nil? ? nil: JSON.load(body)
        STDERR.puts "CREATED_SNAP: #{json}"
      end
      json      
    rescue => e
      STDERR.puts "#{e.response.body}"

    end
   
    # Set EBS snapshot commit state: commit_state=[committed|uncommitted]
    def update_snapshot(aws_id,commit_state)
      params = {:aws_id => aws_id, :commit_state => commit_state, :api_version => 1.0 }
       json=nil
       Terminator.terminate(@api_snap_timeout) do
         body = RestClient.put @api_url+"/update_ebs_snapshot.js",params
         puts "UPDATED SNAP: #{aws_id}"
       end
       json      
     rescue => e
      puts "#{e.response.body}"
      raise "Update snapshot FAILED for #{aws_id}: #{commit_state}"
    end

    def cleanup_snapshots(prefix, options={})
      STDERR.puts "options: #{options.inspect}"
      raise "keep_last parameter is required" unless options[:keep_last]
      raise "dailies parameter is required" unless options[:dailies]
      raise "weeklies parameter is required" unless options[:weeklies]
      raise "monthlies parameter is required" unless options[:monthlies]
      raise "yearlies parameter is required" unless options[:yearlies]
      params = {:prefix => prefix, :api_version => 1.0}
      params.merge!(options)
      STDERR.puts "Making RightScale API call to clean old EBS snapshots"
      #STDERR.puts "HERE IS THE URL: #{@api_url}/cleanup_ebs_snapshots.js (PARAMS: #{params.inspect})"
      body = RestClient.put @api_url+"/cleanup_ebs_snapshots.js",params
      json = JSON.load(body)
      STDERR.puts "Snapshots deleted: #{json.length}"
      json      
    rescue => e
      STDERR.puts "#{e.response.body}"

    end
    
    def create_volume_from_snap_size_gb(snap,nickname,sizegb)
       
      params = {:nickname => nickname, :aws_id => snap,:api_version => 1.0, :size => sizegb}
      STDERR.puts "Making a RightScale API call to create a new ebs volume from snapshot #{snap}"
      #STDERR.puts "HERE IS THE URL: #{@api_url}/create_ebs_volume_from_snap.js (PARAMS: #{params.inspect})"
      body = RestClient.post @api_url+"/create_ebs_volume_from_snap.js",params
      json = JSON.load(body)
      STDERR.puts "CREATED_VOLUME_FROM_SNAP: #{json}"
      json
    rescue => e
      STDERR.puts "#{e.response.body}"
    end

    def create_volume_from_snap(snap,nickname)
       
      params = {:nickname => nickname, :aws_id => snap,:api_version => 1.0}
      STDERR.puts "Making a RightScale API call to create a new ebs volume from snapshot #{snap}"
      #STDERR.puts "HERE IS THE URL: #{@api_url}/create_ebs_volume_from_snap.js (PARAMS: #{params.inspect})"
      body = RestClient.post @api_url+"/create_ebs_volume_from_snap.js",params
      json = JSON.load(body)
      STDERR.puts "CREATED_VOLUME_FROM_SNAP: #{json}"
      json
    rescue => e
      STDERR.puts "#{e.response.body}"

    end

   # Creates a volume of a given size, in the zone the current machine exists
   def create_volume(options={})       
      raise "Volume nickname required" unless options[:nickname]
      params = {:nickname => options[:nickname],:size => options[:size], :api_version => 1.0}
      params[:description] = options[:description] if options[:description]
      #STDERR.puts "HERE IS THE URL: #{@api_url}/create_ebs_volume.js (PARAMS: #{params.inspect})"
      body = RestClient.post @api_url+"/create_ebs_volume.js",params
      json = JSON.load(body)
      STDERR.puts "CREATED_VOLUME: #{json}"
      json
    rescue => e
      STDERR.puts "#{e.response.body}"

    end
    
    def detach_volume(device)
      params = {:device => device,:api_version => 1.0}
      STDERR.puts "Making a RightScale API call to detach EBS volume"
      #STDERR.puts "HERE IS THE URL: #{@api_url}/detach_ebs_volume.js (PARAMS: #{params.inspect})"
      body = RestClient.put @api_url+"/detach_ebs_volume.js",params
      json = JSON.load(body)
      STDERR.puts "DETACHED_VOLUME in #{device}"
      json   
    rescue => e
      STDERR.puts "###Error detaching EBS volume!###"
      STDERR.puts "#{e.response.body}"
    end
    
    def attach_volume(vol_id, device)
      params = {:aws_id => vol_id, :device => device,:api_version => 1.0}
      STDERR.puts "Making a RightScale API call to attach EBS volume to #{device}"
      #STDERR.puts "HERE IS THE URL: #{@api_url}/attach_ebs_volume.js (PARAMS: #{params.inspect})"
      body = RestClient.put @api_url+"/attach_ebs_volume.js",params
      json = JSON.load(body)
      STDERR.puts "Attached VOLUME: #{vol_id}"
      json
    rescue => e
      STDERR.puts "#{e.response.body}"

    end

   # Deletes a volume given its aws_id. the wait parameter, specifies if we need to
   # keep on attempting to deleting it in case it's still 'in-use'
   def delete_volume(vol_id,wait=true)
     params = {:aws_id => vol_id,:api_version => 1.0}
      success=false
      20.times do |i|  
        begin
          STDERR.puts "Making RightScale API call to delete EBS volume"
          #STDERR.puts "HERE IS THE URL: #{@api_url}/delete_ebs_volume.js (PARAMS: #{requestify(params)})"
          body = RestClient.delete @api_url+"/delete_ebs_volume.js"+"?"+requestify(params)
          success=true
          #json = JSON.load(body)
          STDERR.puts "Deleted VOLUME: #{vol_id}"
          break
        rescue Exception => e
          STDERR.puts "Error deleting volume: #{e.response.body} (attempt: #{i})"
	  sleep 5
        end
      end
      raise "Couldn't delete volume #{vol_id}...aborting." unless success
   end    

    def wait_for_attachment(device)
      success=false
      300.times do |attempt|  
        if File.blockdev?(device)
          success=true
          break
        end
        putc "."
        sleep(1)    
      end
      raise EBSRemoteExecException.new(nil,$?,"Timeout while waiting for the device to attach") unless success
      STDERR.puts "Done!"
    end
    
    def wait_for_detachment(device, timeout = 120)
      success=false
      timeout.times do |attempt|  
        if ! File.blockdev?(device)
          success=true
          break
        end
        putc "."
        sleep(1)    
      end
      raise EBSRemoteExecException.new(nil,$?,"Timeout while waiting for the device to detach") unless success
      STDERR.puts "Done!"
    end

 
      
    # last_snapshot is a hash that contains aws_id and nickname    
    def restore_from_snap(last_snapshot, options = {})
      options[:device] = "/dev/sdk" unless options[:device]
      options[:vol_nickname] = last_snapshot["nickname"] unless options[:vol_nickname]
      
      # 5 - Unmount and detach the current EBS volume (forcing to detach the device we're gonna need later for attching ours...)
      umount_and_detach_device({:device => options[:device]})
      # 6- Create the volume from the latest snapshot, attach it to the instance and then mount it
      STDERR.puts "Creating new DB volume from snapshot #{last_snapshot['aws_id']}"
      vol = ( options[:new_size_gb] ? create_volume_from_snap_size_gb(last_snapshot["aws_id"],options[:vol_nickname],options[:new_size_gb] ) :  create_volume_from_snap(last_snapshot["aws_id"],options[:vol_nickname] ) )
      unless vol.nil?
      	STDERR.puts "Attaching new DB volume: #{vol['aws_id']}"
      	att = attach_volume(vol['aws_id'], options[:device])
      	wait_for_attachment(options[:device])
      	FileUtils.mkdir_p self.MountPoint
      	res = `mount -t xfs #{options[:device]} #{self.MountPoint}`
      	raise EBSRemoteExecException.new(nil,$?,"Error mounting newly created volume (#{vol['aws_id']}) on #{options[:device]}:\n"+res) if $? != 0      
      else
	      raise "create volume failed from snapshot"
      end
    end
    
    # Terminate (unmount, detach and delete) the current EBS volume
    def terminate_volume
      device = get_device_mount_point(self.MountPoint)
      STDERR.puts "EBS device detected: #{device}...umounting it..."
      umount_dir(self.MountPoint)
      #detache the mounted volume
      STDERR.puts "Detaching current EBS volume:"
      detached_vol=detach_volume(device)
      STDERR.puts "detachment started (#{detached_vol.inspect})"
#      wait_for_detachment(device, 60)
      delete_volume(detached_vol['aws_id'])
      detached_vol['aws_id']
     rescue => e
	STDERR.puts "Volume detach failed: #{e}"
     end

    # Get the device from a mount point
    def get_device_mount_point( incoming_path )
      mount_lines = `mount`
      raise EBSRemoteExecException.new(nil,$?,mount_lines) if $? != 0
      path = File.ftype(incoming_path) != 'directory'? File.dirname(incoming_path) : incoming_path
      device=nil
      longest = ""
      mount_lines.each_line {|line|
        match = line =~ /(.+)\son\s(.+?)\s.*/
        candidate = $2.strip
        candidate_device = $1.strip
        # Keep the longest prefix matching
        if match && path =~ /^#{candidate}/ && candidate.length > longest.length
          longest = candidate
          device = candidate_device
        end
        }
      unless device
        STDERR.puts "Couldn't find the device for mount point #{path}"
        Kernel.exit(-1)
      end
      device
    end

    # Umount the device pertaining to that directory tree...
    # If exact path is specified, only the exact path is attempted to be unmounted
    # otherwise this function goes down the tree until it finds the mount point (i.e., the 
    # passed path can be a non mounted path..but the function will unmount the filesystem
    # the path belongs to)
    def umount_dir( path , exact_path=true)
      cur_path = path.strip
      success=false
      while cur_path != "/"
        res = `umount #{cur_path} 2>&1`
        if $? == 0
          STDERR.puts "#{cur_path} successfully unmounted"
          success=true
          break
        end
        break if exact_path
        cur_path = (cur_path == "/" ? "/": cur_path.split('/')[0..-2].join('/') )
      end
      raise EBSRemoteExecException.new(nil,$?,"Error unmounting volume holding (#{path}):\n"+res) unless success
    end
    
    # Return a handle to an opened (and exclusively locked file).
    def get_locked_file( lockfile, timeout = 60 )
      cfg_file = File.open(lockfile,"r+")
      success = false
      timeout.times {
        if cfg_file.flock(File::LOCK_EX | File::LOCK_NB )
          success=true
          break
        end
        STDERR.puts "Lockfile is locked...retrying..."
        sleep 1
      }
      raise "Couldn't acquire the lockfile..." unless success
      return cfg_file
    end
        
    private
    
    # Unmounts and detaches the EBS device
    # options[:device] optional == Force detachment of this particular device, even if it doesn't match the device corresponding to the mount point
    def umount_and_detach_device(options={})
      detached_vol=nil
      device = get_device_mount_point(self.MountPoint)
      if(options[:device])
        STDERR.puts "WARNING! the previously mounted device (#{device}) is different from the device we're asking to detach (#{options[:device]})"
        device = options[:device]
      end
      begin
        umount_dir(self.MountPoint)
      rescue Exception => e
        STDERR.puts "#{e}\n ...continuing without unmounting"
      end
      #detache the mounted volume
      STDERR.puts "Detaching volume in device #{device}:"
      begin
        detached_vol=detach_volume(device)
        wait_for_detachment(device)
      rescue Exception => e
        STDERR.puts "Error detaching volume: #{e.response.body}"
        STDERR.puts "...was the previously mounted DB directory not an EBS volume??\n continuing without the detachment..."
      end
      detached_vol
    end
    

    def name_with_prefix(prefix, name)
      prefix ? "#{prefix}[#{name}]" : name.to_s
    end

    
    # Convert the given parameters to a request string. The parameters may
    # be a string, +nil+, or a Hash.
    def requestify(parameters, prefix=nil)
      if Hash === parameters
        return nil if parameters.empty?
        parameters.map { |k,v| requestify(v, name_with_prefix(prefix, k)) }.join("&")
      elsif Array === parameters
        parameters.map { |v| requestify(v, name_with_prefix(prefix, "")) }.join("&")
      elsif prefix.nil?
        parameters
      else
        "#{CGI.escape(prefix)}=#{CGI.escape(parameters.to_s)}"
      end
    end
  end

end
