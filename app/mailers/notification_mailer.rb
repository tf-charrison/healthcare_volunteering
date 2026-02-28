class NotificationMailer < ApplicationMailer
  def new_notification(notification)
    @notification = notification
    mail(
      to: notification.recipient.email,
      subject: "New Notification"
    )
  end
end