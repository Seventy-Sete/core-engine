Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'login/join/:email', to: 'login#join', constraints: { email: /[^\/]+/ }
      post 'login/auth/:user_id', to: 'login#auth'
    end
  end
end
