Rails.application.routes.draw do
  get "insights/index"
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

  # config/routes.rb
  devise_scope :organisation do
    get 'organisations/sign_up', to: 'organisations/registrations#new', as: 'new_organisation_registration'
    post 'organisations', to: 'organisations/registrations#create', as: 'organisation_registration'
  end

  get 'insights', to: 'insights#index', as: :insights

  # Opportunities and applications
  resources :opportunities do
    # Volunteer-facing
    resources :applications, only: [:new, :create, :show] do
      patch :change_status, on: :member

      # Messages nested under applications
      resources :messages, only: [:create]

      # ✅ Application Updates nested under applications
      resources :application_updates, only: [:index, :new, :create]
    end

    # Organisation-facing: view applications for this opportunity
    member do
      get :applications_for_org
    end
  end

  resources :organisations, only: [:index, :show] do
    member do
      get :opportunities
    end
    collection do
      get :volunteers
      get :export_volunteers
    end
  end

  # Organisation dashboard
  get "organisation_dashboard", to: "organisations#dashboard"
  get "dashboard", to: "dashboard#index"

  # Profiles
  get   "volunteer_profile",        to: "profiles#volunteer_show", as: :volunteer_profile
  get   "volunteer_profile/edit",   to: "profiles#volunteer_edit", as: :edit_volunteer_profile
  patch "volunteer_profile",        to: "profiles#volunteer_update"

  get   "organisation_profile",        to: "profiles#organisation_show", as: :organisation_profile
  get   "organisation_profile/edit",   to: "profiles#organisation_edit", as: :edit_organisation_profile
  patch "organisation_profile",        to: "profiles#organisation_update"
end
