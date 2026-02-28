class OpportunitiesController < ApplicationController
  before_action :authenticate_organisation!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_opportunity, only: [:show, :edit, :update, :destroy, :applications_for_org]

  def index
    @opportunities = Opportunity.all

    if params[:skill].present?
      @opportunities = @opportunities.where(
        "LOWER(skills_required) LIKE ?",
        "%#{params[:skill].downcase}%"
      )
    end

    if volunteer_signed_in?
      @opportunities = @opportunities.sort_by do |op|
        -op.match_score_for(current_volunteer)
      end
    end
  end

  def show
  end

  def new
    @opportunity = current_organisation.opportunities.build
  end

  def create
    @opportunity = current_organisation.opportunities.build(opportunity_params)

    if @opportunity.save
      # Notify all volunteers about the new opportunity
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

  def edit
  end

  def update
    if @opportunity.update(opportunity_params)
      redirect_to @opportunity, notice: "Opportunity updated successfully."
    else
      flash.now[:alert] = "Could not update opportunity."
      render :edit
    end
  end

  def destroy
    @opportunity.destroy
    redirect_to opportunities_path, notice: "Opportunity deleted successfully."
  end

  # opportunities_controller.rb
  def applications_for_org
    # Only the organisation who owns this opportunity can see its applications
    unless @opportunity.organisation == current_organisation
      redirect_to opportunities_path, alert: "Not authorized"
      return
    end

    @applications = @opportunity.applications.includes(:volunteer)

    if params[:skill].present?
      @applications = @applications.select do |app|
        app.volunteer.skills.to_s.downcase.include?(params[:skill].downcase)
      end
    end

    if params[:experience].present?
      @applications = @applications.select do |app|
        app.volunteer.experience.to_s.downcase.include?(params[:experience].downcase)
      end
    end

    # ✅ Compliance filters
    if params[:cpr_certified] == "1"
      @applications = @applications.select do |app|
        app.volunteer.cpr_certified?
      end
    end

    if params[:hipaa_trained] == "1"
      @applications = @applications.select do |app|
        app.volunteer.hipaa_trained?
      end
    end

    if params[:background_checked] == "1"
      @applications = @applications.select do |app|
        app.volunteer.background_checked?
      end
    end
  end

  # GET /organisations/:id/opportunities
  def opportunities
    @opportunities = @organisation.opportunities
    if params[:skill].present?
      @opportunities = @opportunities.where("LOWER(skills_required) LIKE ?", "%#{params[:skill].downcase}%")
    end
  end

  private

  def set_opportunity
    @opportunity = Opportunity.find(params[:id])
  end

  def opportunity_params
    params.require(:opportunity).permit(:title, :description, :location, :start_date, :end_date, :skills_required)
  end
end
