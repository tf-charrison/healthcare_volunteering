class ApplicationsController < ApplicationController
  before_action :authenticate_volunteer!
  before_action :set_opportunity

  def new
    @application = @opportunity.applications.build
  end

  def create
    @application = @opportunity.applications.build(application_params)
    @application.volunteer = current_volunteer

    if @application.save
      redirect_to @opportunity, notice: "Application submitted successfully."
    else
      render :new, alert: "Please correct the errors below."
    end
  end

  def index
    @applications = @opportunity.applications
  end

  private

  def set_opportunity
    @opportunity = Opportunity.find(params[:opportunity_id])
  end

  def application_params
    params.require(:application).permit(
      :cover_letter,
      :availability,
      :experience_summary
    )
  end
end
