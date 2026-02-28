# app/jobs/opportunity_expiry_job.rb
class OpportunityExpiryJob < ApplicationJob
  queue_as :default

  def perform
    Opportunity.expiring_within(3).find_each do |opportunity|
      Volunteer.find_each do |volunteer|
        VolunteerMailer.opportunity_expiry(volunteer, opportunity).deliver_later
      end
    end
  end
end