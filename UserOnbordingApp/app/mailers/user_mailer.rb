class UserMailer < ApplicationMailer
  default to: 'testingrails8@gmail.com'

  def send_email(help)
  	@help = help
    mail(from: @help.email, subject: 'Welcome to My Awesome Site')
  end
end
