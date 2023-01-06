Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'login/join/:email', to: 'login#join', constraints: { email: /[^\/]+/ }
      post 'login/auth/:user_id', to: 'login#auth'

      get 'nubank/:cpf/auth', to: 'nubank#auth'
      get 'nubank/:cpf/account/balance', to: 'nubank#account_balance'
      get 'nubank/:cpf/account/feed', to: 'nubank#account_feed'
    end
  end
end
