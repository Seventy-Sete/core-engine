Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'auth/join/:email', to: 'login#join_with_email', constraints: { email: /[^\/]+/ }
      get 'auth/login/:email', to: 'login#login_with_email', constraints: { email: /[^\/]+/ }
      get 'auth/token-login/:token/:user_id', to: 'login#login_with_token'
      get 'auth/create-account/:token/:email', to: 'login#create_account'
      get 'auth/reset-password/:token/:user_id', to: 'login#reset_password'

      get 'nubank/:cpf/auth', to: 'nubank#auth'
      get 'nubank/:cpf/account/balance', to: 'nubank#account_balance'
      get 'nubank/:cpf/account/feed', to: 'nubank#account_feed'
    end
  end
end
