require 'action_mailer'
require 'mailgun'
require 'railgun'

ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.add_delivery_method :mailgun, Railgun::Mailer
ActionMailer::Base.delivery_method = :mailgun
ActionMailer::Base.mailgun_settings = {
  api_key: ENV['MAILGUN_KEY'],
  domain: ENV['MAILGUN_DOMAIN'],
}
ActionMailer::Base.view_paths= File.dirname(__FILE__)

class Mailer < ActionMailer::Base

  def daily_email signals
    @signals = signals
    mail(
      to: ENV['CCTS_MAIL_TO'],
      from: "sektor@#{ENV['MAILGUN_DOMAIN']}",
      subject: "Trading Signals from CCTS!"
    ) do |format|
      format.text
      format.html
    end
  end
end
