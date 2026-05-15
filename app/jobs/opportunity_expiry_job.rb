# app/jobs/opportunity_expiry_job.rb
class OpportunityExpiryJob < ApplicationJob
  # Use the default ActiveJob queue for processing
  queue_as :default

  # This job finds opportunities expiring within a given window
  # and sends notification emails to all volunteers
  def perform
    # Iterate over opportunities expiring within the next 3 days (based on scope)
    Opportunity.expiring_within(3).find_each do |opportunity|

      # Loop through all volunteers and send each one an email notification
      # Emails are enqueued asynchronously using deliver_later
      Volunteer.find_each do |volunteer|
        VolunteerMailer.opportunity_expiry(volunteer, opportunity).deliver_later
      end

    end
  end
end