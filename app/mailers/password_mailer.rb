class PasswordMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.password_mailer.reset.subject
  #
  def reset
    set_smtp_settings

    if params[:user].present?
      @token = params[:user].signed_id(purpose: 'password_reset', expires_in: 15.minutes)
      mail to: params[:user].email
    elsif params[:company].present?
      @token = params[:company].signed_id(purpose: 'password_reset', expires_in: 15.minutes)
      mail to: params[:company].email
    end
  end

  private

  def set_smtp_settings
    if params[:user].present?
      smtp_settings = params[:user].smtp_settings
    else
      smtp_settings = params[:company].smtp_settings
    end
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
