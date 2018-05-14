class AfterSigninController < ApplicationController
  include Wicked::Wizard
  steps :agreement

  def show
    @user = current_user
    case step
    when :agreements
      @hello = "hi"
    end
    render_wizard   
  end
end