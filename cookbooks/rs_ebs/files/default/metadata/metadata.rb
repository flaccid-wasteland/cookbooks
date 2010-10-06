#!/usr/bin/ruby

Dir.glob("/opt/rightscale/metadata/rs_*") {|filename|
	open(filename, 'r') { |m|
		k = File.basename(filename).upcase
		v = m.readline
		ENV["#{k}"] = "#{v}"
	}
}

#puts 'New ENV:'
#ENV.each {|k,v|
#	puts "#{k}" + '=' + "#{v}"
#}
