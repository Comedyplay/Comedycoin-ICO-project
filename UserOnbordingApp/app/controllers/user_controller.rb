class UserController < ApplicationController
  include Wicked::Wizard
  steps :agreement, :identity, :payment, :confirmation

  def show
    @user = current_user
    case step
    when :agreement
      render_wizard
    when :identity
      # if @user.validate_user.aggrement_verified == true
      #   @user_profile = UserProfile.new
        render_wizard
      # else
      #   redirect_to wizard_path(:agreement)
      # end
    when :payment
      # if @user.validate_user.identity_verified == true
        render_wizard
      # else
      #   redirect_to wizard_path(:identity)
      # end
    when :confirmation
      # if @user.validate_user.payment_verified == true
        render_wizard
      # else
      #   redirect_to wizard_path(:payment)
      # # end
    end   
  end

  def update
    @user = current_user
    case step
    when :agreement
      if @user.validate_user.present?
        @user.validate_user.update_attributes(validate_user_params)
        render_wizard(@user.validate_user)
      else
        @validate_user = ValidateUser.new(validate_user_params)
        @validate_user.save
        render_wizard(@validate_user)
      end
    when :identity
      byebug
      if @user.user_profile.present?
        if @user.user_profile.update_attributes(user_profile_params)
          redirect_to identity_path("select_identity")
        else
          render :identity, locals: {user_profile: @user.user_profile}
        end
      else
        @user_profile = UserProfile.new(user_profile_params)
        if @user_profile.save
          redirect_to identity_path("select_identity")
        else
          render :identity, locals: {user_profile: @user_profile}
        end
      end
    end
  end

  def send_email
    @help = Help.new(help_params)
    @help.save
    UserMailer.send_email(@help).deliver_now
  end

  private

  def user_profile_params
    params.require(:user_profile).permit(:first_name, :last_name, :gender, :dob, :country, :phone_number, :building_number, :street_address, :city, :state, :country_address, :zip_code, :user_id)
  end

  def help_params
    params.require(:help).permit(:name, :email, :description, :image)
  end

  def validate_user_params
    params.require(:validate_user).permit(:aggrement_verified, :identity_verified, :payment_verified, :confirmation_verified, :user_id)
  end
end
