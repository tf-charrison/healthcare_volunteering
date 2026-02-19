class OpportunitiesController < ApplicationController
  before_action :authenticate_organisation!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_opportunity, only: [:show, :edit, :update, :destroy, :applications_for_org]

  def index
    @opportunities = Opportunity.order(start_date: :asc)
  end

  def show
  end

  def new
    @opportunity = current_organisation.opportunities.build
  end

  def create
    @opportunity = current_organisation.opportunities.build(opportunity_params)
    if @opportunity.save
      redirect_to @opportunity, notice: "Opportunity created successfully."
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

  def applications_for_org
    # Only the organisation who owns this opportunity can see its applications
    unless @opportunity.organisation == current_organisation
      redirect_to opportunities_path, alert: "Not authorized"
      return
    end

    @applications = @opportunity.applications.includes(:volunteer)
  end

  private

  def set_opportunity
    @opportunity = Opportunity.find(params[:id])
  end

  def opportunity_params
    params.require(:opportunity).permit(:title, :description, :location, :start_date, :end_date, :skills_required)
  end
end
