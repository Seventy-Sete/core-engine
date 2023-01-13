Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :nubank, only: [] do
        collection do
          get 'new_auth_to/:bcn', to: 'nubank#new_auth_to', constraints: { bcn: /[^\/]+/ }
        end
        member do
          get 'auth_validate', to: 'nubank#auth_validate'
          get 'auth_request_email_code'
          get 'exchange_certificates/:email_code', to: 'nubank#exchange_certificates'
          get 'account_balance', to: 'nubank#account_balance'
          get 'credit_balances', to: 'nubank#credit_balances'
          get 'account_feed', to: 'nubank#account_feed'
          get 'credit_feed', to: 'nubank#credit_feed'
          get 'account_details', to: 'nubank#account_details'
          get 'credit_details', to: 'nubank#credit_details'
        end
      end

      resources :auth, only: [] do
        collection do
          get 'join/:email', to: 'auth#join_with_email', constraints: { email: /[^\/]+/ }
          get 'login/:email', to: 'auth#login_with_email', constraints: { email: /[^\/]+/ }
          get 'token-login/:token/:user_id', to: 'auth#login_with_token'
          get 'create-account/:token/:email', to: 'auth#create_account'
          get 'reset-password/:token/:user_id', to: 'auth#reset_password'
        end
      end
    end
  end
end