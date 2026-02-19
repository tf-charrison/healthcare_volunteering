Rails.application.routes.draw do
  get "dashboard/index"
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
    # Volunteer-facing
    resources :applications, only: [:new, :create, :show] do
      patch :change_status, on: :member

      # Messages nested under applications
      resources :messages, only: [:create]
    end

    # Organisation-facing: view applications for this opportunity
    member do
      get :applications_for_org
    end
  end

  # Organisation dashboard
  get "organisation_dashboard", to: "organisations#dashboard"
  get "dashboard", to: "dashboard#index"

  # Profiles
  get   "volunteer_profile",        to: "profiles#volunteer_show"
  get   "volunteer_profile/edit",   to: "profiles#volunteer_edit"
  patch "volunteer_profile",        to: "profiles#volunteer_update"

  get   "organisation_profile",        to: "profiles#organisation_show"
  get   "organisation_profile/edit",   to: "profiles#organisation_edit"
  patch "organisation_profile",        to: "profiles#organisation_update"
end
