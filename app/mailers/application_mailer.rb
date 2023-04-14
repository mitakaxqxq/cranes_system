class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"

  def smtp_settings
    Rails.application.config.action_mailer.smtp_settings
  end
end
