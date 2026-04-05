# app/controllers/organisations/registrations_controller.rb
class Organisations::RegistrationsController < Devise::RegistrationsController
  # GET /organisations/sign_up
  # Renders the sign-up form (uses Devise default)
  def new
    super
  end

  # POST /organisations
  # Creates a new organisation account via Devise
  def create
    super
  end

  private

  # Allow additional fields during sign up
  def sign_up_params
    params.require(:organisation).permit(:email, :name, :phone_number, :address, :password, :password_confirmation)
  end

  # Allow additional fields during account update (requires current_password)
  def account_update_params
    params.require(:organisation).permit(:email, :name, :phone_number, :address, :password, :password_confirmation, :current_password)
  end
end