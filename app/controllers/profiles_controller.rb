class ProfilesController < ApplicationController
  # Restrict volunteer profile actions to authenticated volunteers
  before_action :authenticate_volunteer!, only: [:volunteer_edit, :volunteer_update, :volunteer_show]

  # Restrict organisation profile actions to authenticated organisations
  before_action :authenticate_organisation!, only: [:organisation_edit, :organisation_update, :organisation_show]

  # ------------------------
  # Volunteer profile actions
  # ------------------------

  # GET /profile/volunteer
  # Displays the current volunteer's profile
  def volunteer_show
    @volunteer = current_volunteer
  end

  # GET /profile/volunteer/edit
  # Renders the edit form for the current volunteer
  def volunteer_edit
    @volunteer = current_volunteer
  end

  # PATCH/PUT /profile/volunteer
  # Updates the current volunteer's profile
  def volunteer_update
    @volunteer = current_volunteer

    # If password fields are left blank, remove them so Devise doesn't attempt to update them
    if params[:volunteer][:password].blank? && params[:volunteer][:password_confirmation].blank?
      params[:volunteer].extract!(:password, :password_confirmation)
    end

    if @volunteer.update(volunteer_params)
      redirect_to volunteer_profile_path, notice: "Profile updated successfully."
    else
      flash.now[:alert] = "Could not update profile."
      render :volunteer_show
    end
  end

  # ----------------------------
  # Organisation profile actions
  # ----------------------------

  # GET /profile/organisation
  # Displays the current organisation's profile
  def organisation_show
    @organisation = current_organisation
  end

  # GET /profile/organisation/edit
  # Renders the edit form for the organisation
  def organisation_edit
    @organisation = current_organisation
  end

  # PATCH/PUT /profile/organisation
  # Updates the current organisation's profile
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

  # Strong parameters for volunteer profile updates
  def volunteer_params
    params.require(:volunteer).permit(
      :email,
      :first_name,
      :last_name,
      :phone_number,
      :password,
      :password_confirmation,
      :experience,
      :skills,
      :availability,
      :cpr_certified,
      :first_aid_certified,
      :hipaa_trained,
      :background_checked
    )
  end

  # Strong parameters for organisation profile updates
  def organisation_params
    params.require(:organisation).permit(
      :email,
      :name,
      :phone_number,
      :address,
      :location
    )
  end
end