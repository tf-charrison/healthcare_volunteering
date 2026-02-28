# Preview all emails at http://localhost:3000/rails/mailers/volunteer_mailer
class VolunteerMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/volunteer_mailer/opportunity_expiry
  def opportunity_expiry
    VolunteerMailer.opportunity_expiry
  end
end
