#!/usr/bin/env ruby
# A simple Bootstrap Script for install rvm ruby  
# chetan.muneshwar@gmail.com

require 'rubygems'
require 'net/ssh'
require 'net/scp'
require 'net/sftp'

$CONF_FILE_NAME = ARGV[0]
$DEPLOYMENT_MODE = ARGV[1]

require 'yaml'
class AutoDeploy

 def initialize(config_name,deploy_mode)
  @config_name = config_name
  @deploy_mode = deploy_mode
end

def read_config
 config = YAML.load_file("#{@config_name}")
 @uname = config["config"]["uname"]
 @ip = config["config"]["ip"]
 @pass = config["config"]["pass"]
 @filename = config["config"]["filename"]
 @mod_name = config["config"]["mod_name"]
 @run_program = config["config"]["run_program"]
 @remote_webapps_path= config["config"]["remote_webapps_path"]
end

def read_bootstrap
 config = YAML.load_file("#{@config_name}")
 @os_type = config["bootstrap"]["os_type"]
end	


def bootstrap
	ubuntu_deps = 'sudo apt-get -y install build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion'
  rhel_deps = 'sudo yum install -y gcc-c++ patch readline readline-devel zlib zlib-devel libyaml-devel libffi-devel openssl-devel make bzip2 autoconf automake libtool bison iconv-devel git curl curl-devel'
  rvm_install = 'curl -L https://get.rvm.io | bash -s stable --ruby'
  if @os_type == "ubuntu"
   p "Running Bootstrap For  #{@os_type} Not Working In Progress"
       	    #Net::SSH.start("#{@ip}", "#{@uname}", :password => "#{@pass}" )  do |ssh|
	    # rest = ssh.exec("#{ubuntu_deps}")
	    #end	
    elsif  @os_type == "rhel"
      p " Running Bootstrap For #{@os_type}"
      Net::SSH.start("#{@ip}", "#{@uname}", :password => "#{@pass}" )  do |ssh|
       ssh.open_channel do |channel|
         channel.request_pty do |ch, success|
          if success
            ch.exec "#{rhel_deps} && #{rvm_install}"
            ch.on_data do |ch , data|
		data.inspect
        	 if data.inspect.include? "[sudo]"
		 channel.send_data("#{@pass}\n")
          	   sleep 0.1
        	 elsif data.inspect.include? "Password:"
	  	 channel.send_data("#{@pass}\n")	 
		 elsif data.inspect.include? "\'q\'"
                 channel.send_data("q")
                   sleep 0.1
                 end

             puts data
             ch.wait
           end
         end
       end
     end	
   end		  
 end
end
end


