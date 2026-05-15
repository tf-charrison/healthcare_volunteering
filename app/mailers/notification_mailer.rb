class NotificationMailer < ApplicationMailer
  # Sends an email when a new notification is created
  def new_notification(notification)
    @notification = notification

    # Deliver the email to the notification recipient with a generic subject
    mail(
      to: notification.recipient.email,
      subject: "New Notification"
    )
  end
end