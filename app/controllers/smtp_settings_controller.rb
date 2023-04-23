class SmtpSettingsController < ApplicationController
    before_action :require_user_logged_in!

    def edit
        if Current.user.smtp_settings.nil?
            Current.user.smtp_settings = SmtpSetting.new(
              address: 'smtp.gmail.com',
              port: 587,
              user_name: Current.user[:email],
              authentication: 'plain',
              enable_starttls_auto: true,
              openssl_verify_mode: 'none'
            )
            Current.user.smtp_settings.save
        end
        @smtp_settings = Current.user.smtp_settings
    end

    def update
        @smtp_settings = Current.user.smtp_settings || Current.user.build_smtp_settings
        if @smtp_settings.update(smtp_settings_params)
          redirect_to root_path, notice: 'SMTP настройките бяха ъпдейтнати успешно.'
        else
          render :edit
        end
    end

    def smtp_settings_params
        params.require(:smtp_setting).permit(:password).tap do |settings|
            key = ENV['SMTP_PASSWORD_ENCRYPTION_KEY']
            crypt = ActiveSupport::MessageEncryptor.new(key)
            encrypted_password = crypt.encrypt_and_sign(settings[:password])
            settings[:password] = encrypted_password
        end
    end
end