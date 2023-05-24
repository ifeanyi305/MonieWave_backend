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
      post 'rate/create', to: 'exchange_rates#create'
      get 'rate/latest_all', to: 'exchange_rates#all_last_rate'
      get 'rate/currency_latest', to: 'exchange_rates#last_currency_rate'
      get 'rate/history', to: 'exchange_rates#all_rates_data'
      # Transaction fee resources
      resources :fee_ranges, only: [:create, :index]
      put 'fee_range', to: 'fee_ranges#update_fee'
      delete 'fee_range', to: 'fee_ranges#delete_fee'
      # Beneficiary resources
      resources :beneficiaries, only: [:create, :index, :destroy]
      # Transfer Resources
      resources :transfers, only: [:create, :index]
      resources :users, only: [:create, :index]
      # Password reset routes
        post 'password/forgot', to: 'users#forgot_password'
        post 'password/reset', to: 'users#reset_password'
    end
  end
end
