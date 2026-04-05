class ApplicationUpdatesController < ApplicationController
  # Restrict creating new updates to authenticated organisations only
  # (You may adjust this to allow volunteers or other roles if needed)
  before_action :authenticate_organisation!, only: [:new, :create]

  # Load the parent application for all actions using the nested route param
  before_action :set_application

  # GET /applications/:application_id/application_updates
  # Displays a list of updates associated with a specific application
  def index
    @updates = @application.application_updates.order(created_at: :desc)
  end

  # GET /applications/:application_id/application_updates/new
  # Renders a form for creating a new application update
  def new
    @update = @application.application_updates.new
  end

  # POST /applications/:application_id/application_updates
  # Creates a new update linked to the application and assigns the current user
  def create
    @update = @application.application_updates.new(application_update_params)

    # Associate the update with the currently signed-in organisation
    # (Could be adapted to support volunteers via polymorphic association)
    @update.user = current_organisation

    if @update.save
      # On success, redirect back to the updates index with a success message
      redirect_to application_application_updates_path(@application), notice: "Update added successfully."
    else
      # On failure, re-render the form and display an error message
      flash.now[:alert] = "Could not save update."
      render :new
    end
  end

  private

  # Fetch the parent Application record based on the nested route parameter
  def set_application
    @application = Application.find(params[:application_id])
  end

  # Strong parameters for creating an application update
  # Only allows the message field to be submitted from the form
  def application_update_params
    params.require(:application_update).permit(:message)
  end
end