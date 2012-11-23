class ApplicationController < ActionController::Base
  protect_from_forgery

  def load_facebook_client_side_config
    facebook_config = {}  # JUST FOR TESTING GON... should be global and loaded in some initializer
    facebook_config[Rails.env] = {:app_id => "this is just a test for gon"}
    gon.facebook_config = facebook_config[Rails.env]
  end

end
