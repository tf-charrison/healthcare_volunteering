class VolunteerMailer < ApplicationMailer
  def opportunity_expiry(volunteer, opportunity)
    @volunteer = volunteer
    @opportunity = opportunity
    mail(
      to: @volunteer.email,
      subject: "Opportunity Expiring Soon: #{@opportunity.title}"
    )
  end
end