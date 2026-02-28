class ApplicationUpdatesController < ApplicationController
  before_action :authenticate_organisation!, only: [:new, :create] # Or volunteer as needed
  before_action :set_application

  def index
    @updates = @application.application_updates.order(created_at: :desc)
  end

  def new
    @update = @application.application_updates.new
  end

  def create
    @update = @application.application_updates.new(application_update_params)
    @update.user = current_organisation # or current_volunteer if polymorphic

    if @update.save
      redirect_to application_application_updates_path(@application), notice: "Update added successfully."
    else
      flash.now[:alert] = "Could not save update."
      render :new
    end
  end

  private

  def set_application
    @application = Application.find(params[:application_id])
  end

  def application_update_params
    params.require(:application_update).permit(:message)
  end
end