Rails.application.routes.draw do
  resources :immunizations
  resources :children
  devise_for :medics
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
