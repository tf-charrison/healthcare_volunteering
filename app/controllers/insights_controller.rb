class InsightsController < ApplicationController
  before_action :authenticate_organisation!
  def index
    # Volunteer metrics
    @total_volunteers = Volunteer.count
    @active_volunteers = Volunteer.where('updated_at >= ?', 30.days.ago).count

    # Opportunities metrics
    @total_opportunities = Opportunity.count
    @matched_opportunities = Opportunity.joins(:applications).distinct.count

    # Completed tasks
    @completed_tasks = Application.where(status: 'completed').count
  end
end