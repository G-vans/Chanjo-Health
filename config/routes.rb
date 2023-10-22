Rails.application.routes.draw do
  resources :follows
  resources :immunization_schedules, only: [:index, :new, :create, :show, :edit, :destroy] do
    member do
      patch 'update_status'
    end
  end

  resources :immunizations, only: [:index, :new, :create, :show, :edit, :destroy]
  resources :children do
    resources :immunizations
    resources :immunization_schedules do
      member do
        patch 'update_status' # Nested under `immunization_schedules` for updating immunization schedules
        post 'follow_up_call'
      end
    end
  end
  
  
  devise_for :medics
  get 'dashboard/index'
  post '/send_sms', to: 'children#send_sms'
  post '/welcome_sms', to: 'children#send_welcome_sms'
  # post 'immunization_schedule/follow_up_call'
  # post 'follows/follow_up_call'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"
end
