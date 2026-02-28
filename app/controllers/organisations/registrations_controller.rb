# app/controllers/organisations/registrations_controller.rb
class Organisations::RegistrationsController < Devise::RegistrationsController
  # GET /organisations/sign_up
  def new
    super
  end

  # POST /organisations
  def create
    super
  end

  private

  # Permit extra fields for sign up / account update
  def sign_up_params
    params.require(:organisation).permit(:email, :name, :phone_number, :address, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:organisation).permit(:email, :name, :phone_number, :address, :password, :password_confirmation, :current_password)
  end
end