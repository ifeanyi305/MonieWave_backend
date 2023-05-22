Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "root#index"
  post 'auth/login', to: 'authentication#login' , as: 'login'
  namespace :api do
    namespace :v1 do
      # OTP email routes
      post 'otp/create_otp', to: 'email_otp#create_otp'
      post 'otp/verify_otp', to: 'email_otp#verify_otp'
      #  Exchange rates routes
      post 'rate/create', to: 'exchange_rate#create'
      get 'rate/latest_all', to: 'exchange_rate#all_last_rate'
      get 'rate/currency_latest', to: 'exchange_rate#last_currency_rate'
      get 'rate/history', to: 'exchange_rate#all_rates_data'
      # Transaction fee resources
      resources :fee_range, only: [:create, :index, :update, :destroy]
      resources :users, only: [:create, :index]
      # Password reset routes
        post 'password/forgot', to: 'users#forgot_password'
        post 'password/reset', to: 'users#reset_password'
    end
  end
end
