class EventMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.event_mailer.contact_email.subject
  #
  def contact_email(event, contact_detail)
  	@contact_detail = contact_detail
    @event = event
    mail to: event.try(:user).try(:email), subject: "contact_email"
  end
end
