class IdentityController < ApplicationController
  include Wicked::Wizard
  steps :select_identity, :upload_identity, :identity_preview, :upload_photo, :check_photo, :verify_identity, :verified_identity

  def show
    @user = current_user
    case step
    when :select_identity
      if @user.user_profile.present?
        render_wizard
      else
        redirect_to wizard_path(:identity)
      end
    when :upload_identity
      render_wizard
    when :identity_preview
      render_wizard
    when :upload_photo
      render_wizard
    when :check_photo
      render_wizard
    when :verify_identity
      if @user.validate_user.present?
        if @user.validate_user.identity_verified == true
          redirect_to wizard_path(:verified_identity)
        else
          render_wizard
        end
      end
    when :verified_identity
      if @user.validate_user.present?
        if @user.validate_user.identity_verified == true
          render_wizard
        else
          redirect_to wizard_path(:verify_identity)
        end
      end
    end 
  end

  def update
    @user = current_user
    case step
    when :upload_identity, :upload_photo
      @user.user_profile.update_attributes(user_profile_params)
      render_wizard(@user.user_profile)
    end
  end

  private

  def user_profile_params
    params.require(:user_profile).permit(:identity_photo, :user_photo)
  end
end
