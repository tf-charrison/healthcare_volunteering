class InsightsController < ApplicationController
  before_action :authenticate_organisation!

  def index
    # Volunteer metrics
    @total_volunteers = Volunteer.count
    @active_volunteers = Volunteer.where('updated_at >= ?', 30.days.ago).count

    # Opportunities metrics
    @total_opportunities = Opportunity.count
    @matched_opportunities = Opportunity.joins(:applications).distinct.count
    @unmatched_opportunities = @total_opportunities - @matched_opportunities

    # Completed tasks
    @completed_tasks = Application.where(status: 'completed').count

    # Volunteer signups last 30 days (grouped by day)
    @volunteer_signups = Volunteer
      .where('created_at >= ?', 30.days.ago)
      .group("DATE(created_at)")
      .count
  end
end