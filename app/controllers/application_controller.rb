class ApplicationController < ActionController::Base
  attr_reader :current_user

  #TODO: fix CSRF issues
  skip_before_action :verify_authenticity_token
  

  private
  #TODO: set current user via JWT
  def current_user
    User.find_by(name: "admin")
  end
end
