# app/controllers/volunteers/registrations_controller.rb
class Volunteers::RegistrationsController < Devise::RegistrationsController
  private

  # Permit extra fields for sign up / account update
  def sign_up_params
    params.require(:volunteer).permit(:email, :first_name, :last_name, :phone_number, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:volunteer).permit(:email, :first_name, :last_name, :phone_number, :password, :password_confirmation, :current_password)
  end
end
