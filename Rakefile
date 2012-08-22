require 'rake'
require 'bundler'
Bundler.setup
Bundler.require(:default) if defined?(Bundler)

Dir["./chef_deploy.rb"].each {|file| require file }

task :hi do 
  desc "HI Welcome To RVM boostrap"
  print "please try 'rake --tasks' to see all task \n"
end

task :default  => [:hi]
  desc "bootstrap"
  task :bootstrap do
     deploy = AutoDeploy.new("config.yml","production")
     deploy.read_config
     deploy.read_bootstrap
     deploy.bootstrap
end
 
  
