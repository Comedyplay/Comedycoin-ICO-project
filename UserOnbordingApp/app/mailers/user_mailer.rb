class UserMailer < ApplicationMailer
  default to: 'testingrails8@gmail.com'

  def send_email(help)
  	@help = help
    mail(from: @help.email, subject: 'Welcome to My Awesome Site')
  end

  def resend_email(user)
  	@user = user
    mail(to: @user.email, from: 'testingrails8@gmail.com', subject: 'Welcome to My Awesome Site')
  end
end
