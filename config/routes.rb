Rails.application.routes.draw do
  root 'opportunities#index'

  devise_for :volunteers
  devise_for :organisations

  resources :opportunities do
    resources :applications, only: [:create, :index]
  end
end
