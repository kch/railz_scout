RAILZ_SCOUT_CONFIG = {
  # Set this to the URL of your FogBugz installation. 
  # the scoutSubmit script is part of your installation. For Windows setups
  # it has an extension of .asp, for Mac/Unix setups, .php.
  :url => "http://example.com/FogBugz/scoutSubmit.php",

  # The following are the defaults already, uncomment and change as you need

  # The name of an existing project in FogBugz. Likely, the name of the 
  # project for this Rails app.
  # :project => 'Inbox',
  
  # An existing area within the project in FogBugz. Misc is the default for 
  # every app, but you might want to have one area specifically for 
  # RailzScout reports.
  # :area => 'Misc',

  # Username: The name of a user in your FogBugz installation. We recommend
  # you create a virtual user named RailzScout so you know which cases were
  # automatically submitted.
  # :username => 'RailzScout',
  
  # This is the email address of the correspondent, AKA the user who reported
  # the bug. You should probably leave this nil unless you implement some
  # functionality for the user to comment on the bug he experienced.
  # :email => nil,
  
  # Force FogBugz to always create a new bug, instead of appending to an
  # existing bug with identical title.
  # :force_new => false,
  
  # For the following exceptions, do not post to FogBugz, just render 404.
  # Setting exceptions here override the defaults, they are not appended.
  # :ignore_exceptions => [
  #   ActiveRecord::RecordNotFound, 
  #   ActionController::RoutingError,
  #   ActionController::UnknownController, 
  #   ActionController::UnknownAction,
  #   CGI::Session::CookieStore::TamperedWithCookie,
  # ]
}

RailzScout.config.merge! RAILZ_SCOUT_CONFIG
