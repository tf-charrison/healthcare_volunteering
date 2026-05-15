class OpportunitiesController < ApplicationController
  # Restrict creation and management of opportunities to organisations only
  before_action :authenticate_organisation!, only: [:new, :create, :edit, :update, :destroy]

  # Load the opportunity for actions that require a specific record
  before_action :set_opportunity, only: [:show, :edit, :update, :destroy, :applications_for_org]

  # GET /opportunities
  # Lists all opportunities, with optional filtering and ranking for volunteers
  def index
    @opportunities = Opportunity.all

    # Filter opportunities by required skills (case-insensitive partial match)
    if params[:skill].present?
      @opportunities = @opportunities.where(
        "LOWER(skills_required) LIKE ?",
        "%#{params[:skill].downcase}%"
      )
    end

    # If a volunteer is signed in, sort opportunities by a custom match score
    # This helps surface the most relevant opportunities first
    if volunteer_signed_in?
      @opportunities = @opportunities.sort_by do |op|
        -op.match_score_for(current_volunteer)
      end
    end
  end

  # GET /opportunities/:id
  # Displays a single opportunity
  def show
  end

  # GET /opportunities/new
  # Renders a form to create a new opportunity
  def new
    @opportunity = current_organisation.opportunities.build
  end

  # POST /opportunities
  # Creates a new opportunity and notifies all volunteers
  def create
    @opportunity = current_organisation.opportunities.build(opportunity_params)

    if @opportunity.save
      # Notify all volunteers about the newly created opportunity
      # This loops through all volunteers, creates a notification record,
      # and sends an email asynchronously via Active Job
      Volunteer.find_each do |volunteer|
        notification = volunteer.notifications.create!(
          message: "New opportunity available: #{@opportunity.title}",
          link: opportunity_path(@opportunity)
        )

        NotificationMailer.new_notification(notification).deliver_later
      end

      redirect_to @opportunity, notice: "Opportunity created successfully and volunteers have been notified."
    else
      flash.now[:alert] = "Could not create opportunity."
      render :new
    end
  end

  # GET /opportunities/:id/edit
  # Renders a form to edit an existing opportunity
  def edit
  end

  # PATCH/PUT /opportunities/:id
  # Updates an existing opportunity
  def update
    if @opportunity.update(opportunity_params)
      redirect_to @opportunity, notice: "Opportunity updated successfully."
    else
      flash.now[:alert] = "Could not update opportunity."
      render :edit
    end
  end

  # DELETE /opportunities/:id
  # Deletes an opportunity
  def destroy
    @opportunity.destroy
    redirect_to opportunities_path, notice: "Opportunity deleted successfully."
  end

  # GET /opportunities/:id/applications_for_org
  # Displays all applications for a given opportunity (organisation view)
  def applications_for_org
    # Ensure only the owning organisation can view applications
    unless @opportunity.organisation == current_organisation
      redirect_to opportunities_path, alert: "Not authorized"
      return
    end

    # Load applications with associated volunteers to avoid N+1 queries
    @applications = @opportunity.applications.includes(:volunteer)

    # Filter applications by volunteer skills if provided
    if params[:skill].present?
      @applications = @applications.select do |app|
        app.volunteer.skills.to_s.downcase.include?(params[:skill].downcase)
      end
    end

    # Filter applications by volunteer experience if provided
    if params[:experience].present?
      @applications = @applications.select do |app|
        app.volunteer.experience.to_s.downcase.include?(params[:experience].downcase)
      end
    end

    # Compliance-based filters

    # Filter for CPR certified volunteers
    if params[:cpr_certified] == "1"
      @applications = @applications.select do |app|
        app.volunteer.cpr_certified?
      end
    end

    # Filter for HIPAA trained volunteers
    if params[:hipaa_trained] == "1"
      @applications = @applications.select do |app|
        app.volunteer.hipaa_trained?
      end
    end

    # Filter for background-checked volunteers
    if params[:background_checked] == "1"
      @applications = @applications.select do |app|
        app.volunteer.background_checked?
      end
    end
  end

  # GET /organisations/:id/opportunities
  # Lists opportunities belonging to a specific organisation with optional filtering
  def opportunities
    @opportunities = @organisation.opportunities

    # Filter organisation opportunities by required skills
    if params[:skill].present?
      @opportunities = @opportunities.where("LOWER(skills_required) LIKE ?", "%#{params[:skill].downcase}%")
    end
  end

  private

  # Finds a specific opportunity using the route parameter
  def set_opportunity
    @opportunity = Opportunity.find(params[:id])
  end

  # Strong parameters for opportunity creation and updates
  def opportunity_params
    params.require(:opportunity).permit(:title, :description, :location, :start_date, :end_date, :skills_required)
  end
end