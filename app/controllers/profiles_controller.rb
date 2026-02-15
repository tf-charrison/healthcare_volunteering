class ProfilesController < ApplicationController
  before_action :authenticate_volunteer!, only: [:volunteer_edit, :volunteer_update, :volunteer_show]
  before_action :authenticate_organisation!, only: [:organisation_edit, :organisation_update, :organisation_show]

  # Volunteer profile
  def volunteer_show
    @volunteer = current_volunteer
  end

  def volunteer_edit
    @volunteer = current_volunteer
  end

  def volunteer_update
    @volunteer = current_volunteer

    if params[:volunteer][:password].blank? && params[:volunteer][:password_confirmation].blank?
      params[:volunteer].extract!(:password, :password_confirmation)
    end

    if @volunteer.update(volunteer_params)
      redirect_to volunteer_profile_path, notice: "Profile updated successfully."
    else
      flash.now[:alert] = "Could not update profile."
      render :volunteer_edit
    end
  end

  # Organisation profile
  def organisation_show
    @organisation = current_organisation
  end

  def organisation_edit
    @organisation = current_organisation
  end

  def organisation_update
    @organisation = current_organisation
    if @organisation.update(organisation_params)
      redirect_to organisation_profile_path, notice: "Profile updated successfully."
    else
      flash.now[:alert] = "Could not update profile."
      render :organisation_edit
    end
  end

  private

  def volunteer_params
    params.require(:volunteer).permit(:email, :first_name, :last_name, :phone_number, :password, :password_confirmation)
  end

  def organisation_params
    params.require(:organisation).permit(:email, :name, :phone_number, :address)
  end
end
