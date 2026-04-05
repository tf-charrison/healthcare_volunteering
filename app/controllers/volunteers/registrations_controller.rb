# app/controllers/volunteers/registrations_controller.rb
class Volunteers::RegistrationsController < Devise::RegistrationsController
  private

  # Allow additional fields during sign up
  def sign_up_params
    params.require(:volunteer).permit(:email, :first_name, :last_name, :phone_number, :password, :password_confirmation)
  end

  # Allow additional fields during account update (requires current_password)
  def account_update_params
    params.require(:volunteer).permit(:email, :first_name, :last_name, :phone_number, :password, :password_confirmation, :current_password)
  end
end