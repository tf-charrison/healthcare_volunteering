class VolunteerMailer < ApplicationMailer
  # Sends an email to a volunteer notifying them that an opportunity is expiring soon
  def opportunity_expiry(volunteer, opportunity)
    @volunteer = volunteer
    @opportunity = opportunity

    # Deliver email to the volunteer with a subject that includes the opportunity title
    mail(
      to: @volunteer.email,
      subject: "Opportunity Expiring Soon: #{@opportunity.title}"
    )
  end
end