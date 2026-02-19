Rails.application.routes.draw do
  get "dashboard/index"
  get "applications/create"
  get "applications/index"
  get "home/index"
  root "home#index"

  # Devise routes using custom controllers (only once per model)
  devise_for :volunteers, controllers: {
    registrations: 'volunteers/registrations',
    sessions: 'volunteers/sessions'
  }

  devise_for :organisations, controllers: {
    registrations: 'organisations/registrations',
    sessions: 'organisations/sessions'
  }

  # Opportunities and applications
  resources :opportunities do
    resources :applications, only: [:new, :create, :index]
  end

  get "dashboard", to: "dashboard#index"

  # Profiles
  get   "volunteer_profile",        to: "profiles#volunteer_show"
  get   "volunteer_profile/edit",   to: "profiles#volunteer_edit"
  patch "volunteer_profile",        to: "profiles#volunteer_update"

  get   "organisation_profile",        to: "profiles#organisation_show"
  get   "organisation_profile/edit",   to: "profiles#organisation_edit"
  patch "organisation_profile",        to: "profiles#organisation_update"
end
