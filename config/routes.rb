Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Auth
      get 'auth/join/:email', to: 'auth#join_with_email', constraints: { email: /[^\/]+/ }
      get 'auth/login/:email', to: 'auth#login_with_email', constraints: { email: /[^\/]+/ }
      get 'auth/token-login/:token/:user_id', to: 'auth#login_with_token'
      post 'auth/create-account/:token/:email', to: 'auth#create_account'
      post 'auth/reset-password/:token/:user_id', to: 'auth#reset_password'
    end
  end
end
