this_path = File.dirname(__FILE__)
initializer_template_path = this_path + "/install/initializer.rb"
initializer_destination = RAILS_ROOT + "/config/initializers/railz_scout.rb"
FileUtils.cp initializer_template_path, initializer_destination
