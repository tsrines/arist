Rails.application.routes.draw do
  namespace :api do
    post 'register', to: 'devices#register'
    post 'alive', to: 'devices#alive'
    post 'report', to: 'devices#report'
    put 'terminate', to: 'devices#terminate'
  end
end
