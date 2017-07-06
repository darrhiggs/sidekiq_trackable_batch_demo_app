Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'orders#new'
  post '/orders', to: 'orders#random'
  get '/orders', to: 'orders#index'
end
