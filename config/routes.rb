Rails.application.routes.draw do
  root 'opportunities#index'

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
    resources :applications, only: [:create, :index]
  end

  # Profiles
  get   "volunteer_profile",        to: "profiles#volunteer_show"
  get   "volunteer_profile/edit",   to: "profiles#volunteer_edit"
  patch "volunteer_profile",        to: "profiles#volunteer_update"

  get   "organisation_profile",        to: "profiles#organisation_show"
  get   "organisation_profile/edit",   to: "profiles#organisation_edit"
  patch "organisation_profile",        to: "profiles#organisation_update"
end
