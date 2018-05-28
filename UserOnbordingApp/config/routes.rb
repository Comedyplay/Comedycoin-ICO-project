Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, :skip => :registration
  resources :user
  resources :identity
  resources :payment
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => "home#index"
  match '/send_email',    to: 'user#send_email', via: [:post, :patch]
  get '/users/resend_email',    to: 'users#resend_email'
  match '/mail_send',    to: 'users#mail_send', via: [:post, :patch]
end
