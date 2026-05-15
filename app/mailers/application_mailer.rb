class ApplicationMailer < ActionMailer::Base
  # Default sender email address for all outgoing emails
  default from: "from@example.com"

  # Use the standard mailer layout for all emails
  layout "mailer"
end