Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :user_banks do
        resources :nubank, only: [] do
          collection do
            post 'new_auth_to/:bcn', to: 'nubank#new_auth_to', constraints: { bcn: /[^\/]+/ }
          end
          member do
            # get 'auth_validate', to: 'nubank#auth_validate'
            get 'request_email_code', to: 'nubank#request_email_code'
            post 'exchange_certificates/:email_code', to: 'nubank#exchange_certificates'
          end
        end
      end

      resources :user_banks, only: [] do
        member do
          get 'account_balance', to: 'user_bank#account_balance'
          get 'credit_balances', to: 'user_bank#credit_balances'
          get 'account_feed', to: 'user_bank#account_feed'
          get 'credit_feed', to: 'user_bank#credit_feed'
          get 'account_details', to: 'user_bank#account_details'
          get 'credit_details', to: 'user_bank#credit_details'
        end
      end
      resources :auth, only: [] do
        collection do
          get 'join/:email', to: 'auth#join_with_email', constraints: { email: /[^\/]+/ }
          get 'login/:email', to: 'auth#login_with_email', constraints: { email: /[^\/]+/ }
          get 'token_login/:token/:user_id', to: 'auth#login_with_token'
          post 'create_account/:token/:email', to: 'auth#create_account'
          post 'reset_password/:token/:user_id', to: 'auth#reset_password'
        end
      end
    end
  end
end