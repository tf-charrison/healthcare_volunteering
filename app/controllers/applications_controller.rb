class ApplicationsController < ApplicationController
  before_action :set_opportunity
  before_action :set_application, only: [:show, :change_status]

  # Only require a volunteer for new/create
  before_action :authenticate_volunteer!, only: [:new, :create]
  # Only require an organisation for index/change_status
  before_action :authenticate_organisation!, only: [:index, :change_status]
  # Allow either volunteer or organisation for show
  before_action :authenticate_user!, only: [:show]

  # GET /opportunities/:opportunity_id/applications
  def index
    # Only allow the organisation who owns the opportunity to view applications
    unless current_organisation == @opportunity.organisation
      redirect_to root_path, alert: "You are not authorized to view these applications."
      return
    end

    @applications = @opportunity.applications.includes(:volunteer)
  end

  # GET /opportunities/:opportunity_id/applications/:id
  def show
    # Ensure only the volunteer who submitted or the owning organisation can see it
    unless current_volunteer == @application.volunteer || current_organisation == @opportunity.organisation
      redirect_to root_path, alert: "Not authorized"
      return
    end

    @messages = @application.messages.order(created_at: :asc)
    @message = Message.new
  end  

  # GET /opportunities/:opportunity_id/applications/new
  def new
    @application = @opportunity.applications.build
  end

  # POST /opportunities/:opportunity_id/applications
  def create
    @application = @opportunity.applications.build(application_params)
    @application.volunteer = current_volunteer

    if @application.save
      redirect_to @opportunity, notice: "Application submitted successfully."
    else
      render :new, alert: "Please correct the errors below."
    end
  end

  # PATCH /opportunities/:opportunity_id/applications/:id/change_status
  def change_status
    # Only organisation owning the opportunity can change status
    unless @opportunity.organisation == current_organisation
      redirect_to opportunities_path, alert: "Not authorized"
      return
    end

    if @application.update(status: params[:status])
      redirect_to opportunity_applications_path(@opportunity), notice: "Application updated."
    else
      redirect_to opportunity_applications_path(@opportunity), alert: "Could not update application."
    end
  end

  private

  def set_opportunity
    @opportunity = Opportunity.find(params[:opportunity_id])
  end

  def set_application
    @application = @opportunity.applications.find(params[:id])
  end

  def application_params
    params.require(:application).permit(
      :cover_letter,
      :availability,
      :experience_summary
    )
  end

  # Authenticate either volunteer or organisation
  def authenticate_user!
    unless current_volunteer || current_organisation
      redirect_to root_path, alert: "You must sign in first"
    end
  end
end
