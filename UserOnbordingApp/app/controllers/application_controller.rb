class ApplicationController < ActionController::Base
  protected
  def after_sign_in_path_for(resource)
    # if resource.validate_user.present?
    #   if resource.validate_user.aggrement_verified == true
    #     user_path(:identity)
    #   elsif resource.validate_user.identity_verified == true
    #     user_path(:payment)
    #   elsif resource.validate_user.payment_verified == true
    #     user_path(:confirmation)
    #   else
    #     user_path(:agreement)
    #   end
    # else
      user_path(:agreement)
    # end
  end
end
