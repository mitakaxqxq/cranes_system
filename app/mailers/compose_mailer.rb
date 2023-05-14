class ComposeMailer < ApplicationMailer

  def compose_user(email:, message:)
    set_smtp_settings
    
    mail from: ActionMailer::Base.smtp_settings[:user_name], to: email, subject:'Предстояща проверка на повдигателни съоръжения' do |format|
      format.text { render plain: message }
    end
  end

  def compose_company(email:, subject:, message:)
    set_smtp_settings

    mail from: ActionMailer::Base.smtp_settings[:user_name], to: email, subject: subject do |format|
      format.text { render plain: message }
    end
  end

  private

  def set_smtp_settings
    smtp_settings = Current.user.smtp_settings
    key = ENV['SMTP_PASSWORD_ENCRYPTION_KEY']
    crypt = ActiveSupport::MessageEncryptor.new(key)
    decrypted_password = crypt.decrypt_and_verify(smtp_settings.password)
    ActionMailer::Base.smtp_settings = {
      address: smtp_settings.address,
      port: smtp_settings.port,
      user_name: smtp_settings.user_name,
      password: decrypted_password,
      authentication: smtp_settings.authentication,
      enable_starttls_auto: smtp_settings.enable_starttls_auto,
      openssl_verify_mode: smtp_settings.openssl_verify_mode
    }
  end

end
