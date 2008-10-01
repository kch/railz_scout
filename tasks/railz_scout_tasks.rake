desc "Posts a test bug to the FogBugz instance setup by config/initializers/railz_scout.rb"

namespace :scout do
  task :post_bug => :environment do
    require 'action_controller/test_process'
    exception  = Exception.new
    exception.set_backtrace []
    RailzScout::submit_bug(exception, ActionController::Base.new, ActionController::TestRequest.new({}, {}, {}))
  end
end
