class ApplicationController < ActionController::Base
  protected
  def after_sign_in_path_for(resource)
    after_signin_path(:agreement)
  end	
end
