require 'pathname'

def path(s); Pathname.new(s).cleanpath.to_s end

this_path = path File.dirname(__FILE__)
require path(this_path + '/../../../config/boot')
require 'fileutils'

config_path               = path("#{RAILS_ROOT}/config")
environment_path          = path("#{config_path}/environment.rb")
initializers_path         = path("#{config_path}/initializers")
initializer_template_path = path(this_path + "/install/initializer.rb")
initializer_destination   = path("#{initializers_path}/railz_scout.rb")

unless File.exists? initializers_path
  FileUtils.mkdir_p initializers_path
  required = initializer_destination.sub(/\.rb$/, '')
  open(environment_path, 'a') do |f| 
    f.write "\n\n# == Added by RailzScout:\n"
    f.write "require '#{required}'\n"
  end if IO.read(environment_path).grep(/#{required}/).empty?
end

FileUtils.cp initializer_template_path, initializer_destination
