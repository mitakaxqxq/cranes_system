class ComposeMailer < ApplicationMailer

  def compose(email:)
    if Current.user[:email] != smtp_settings[:user_name]
      raise StandardError
    end
    mail from: smtp_settings[:user_name], to: email
  end
end
