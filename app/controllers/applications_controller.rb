class ApplicationsController < ApplicationController
  # Ensure the parent opportunity is loaded for all actions
  before_action :set_opportunity

  # Load the specific application for actions that require it
  before_action :set_application, only: [:show, :change_status]

  # Only volunteers can create new applications
  before_action :authenticate_volunteer!, only: [:new, :create]

  # Only organisations can view the list of applications or change their status
  before_action :authenticate_organisation!, only: [:index, :change_status]

  # Allow either a volunteer or organisation to access the show action
  before_action :authenticate_user!, only: [:show]

  # GET /opportunities/:opportunity_id/applications
  # Lists all applications for a given opportunity, with optional filtering
  def index
    @opportunity = Opportunity.find(params[:opportunity_id])
    @applications = @opportunity.applications.includes(:volunteer)

    # Filter applications by volunteer skills if a skill param is provided
    if params[:skill].present?
      @applications = @applications.joins(:volunteer)
        .where("LOWER(volunteers.skills) LIKE ?", "%#{params[:skill].downcase}%")
    end

    # Filter applications by volunteer experience if provided
    if params[:experience].present?
      @applications = @applications.joins(:volunteer)
        .where("LOWER(volunteers.experience) LIKE ?", "%#{params[:experience].downcase}%")
    end

    # Sort applications by a custom match score between opportunity and volunteer
    # Higher match score is prioritized (negated for descending order)
    @applications = @applications.sort_by do |application|
      -@opportunity.match_score_for(application.volunteer)
    end
  end

  # GET /opportunities/:opportunity_id/applications/:id
  # Displays a single application along with its messages
  def show
    # Ensure only the application owner (volunteer) or the owning organisation can view
    unless current_volunteer == @application.volunteer || current_organisation == @opportunity.organisation
      redirect_to root_path, alert: "Not authorized"
      return
    end

    # Load messages associated with the application in chronological order
    @messages = @application.messages.order(created_at: :asc)

    # Initialize a new message object for the messaging form
    @message = Message.new
  end  

  # GET /opportunities/:opportunity_id/applications/new
  # Renders the form for a volunteer to create a new application
  def new
    @application = @opportunity.applications.build
  end

  # POST /opportunities/:opportunity_id/applications
  # Creates a new application associated with the current volunteer
  def create
    @application = @opportunity.applications.build(application_params)
    @application.volunteer = current_volunteer

    if @application.save
      redirect_to @opportunity, notice: "Application submitted successfully."
    else
      render :new, alert: "Please correct the errors below."
    end
  end

  # PATCH/PUT action to update the status of an application
  # Only the organisation that owns the opportunity is allowed to perform this action
  def change_status
    @opportunity = Opportunity.find(params[:opportunity_id])
    @application = Application.find(params[:id])

    # Authorisation check: only the owning organisation can change status
    unless @opportunity.organisation == current_organisation
      redirect_to opportunities_path, alert: "Not authorized"
      return
    end

    if @application.update(status: params[:status])
      # Log an update so the volunteer is notified of the status change
      ApplicationUpdate.create!(
        application: @application,
        message: "Your application has been #{params[:status]}.",
        user: current_organisation # tracks who performed the update
      )

      redirect_to applications_for_org_opportunity_path(@opportunity), notice: "Application updated."
    else
      redirect_to applications_for_org_opportunity_path(@opportunity), alert: "Could not update application."
    end
  end

  private

  # Loads the parent opportunity based on the nested route parameter
  def set_opportunity
    @opportunity = Opportunity.find(params[:opportunity_id])
  end

  # Loads the application within the scope of the current opportunity
  def set_application
    @application = @opportunity.applications.find(params[:id])
  end

  # Strong parameters for creating an application
  def application_params
    params.require(:application).permit(
      :cover_letter,
      :availability,
      :experience
    )
  end

  # Custom authentication helper allowing either a volunteer or organisation
  # Redirects to root if neither is signed in
  def authenticate_user!
    unless current_volunteer || current_organisation
      redirect_to root_path, alert: "You must sign in first"
    end
  end
end