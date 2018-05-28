class PaymentController < ApplicationController
  include Wicked::Wizard
  steps :payment, :show_calculator, :send_key

  def show
    @user = current_user
    case step
    when :payment
    when :show_calculator
    when :send_key
    end
    render_wizard
  end

  def update
    @user = current_user
    case step
    when :show_calculator
      if @user.order.present?
        @user.order.update_attributes(order_params)
        render_wizard(@user.order)
      else
        @order = Order.new(order_params)
        @order.save
        render_wizard(@order)
      end
    end
  end

  private

  def order_params
    params.require(:order).permit(:address, :amount, :token, :user_id, :time)
  end
end
