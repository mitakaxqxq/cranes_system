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
        log_smtp_settings_view_opened
    end

    def update
        @smtp_settings = Current.user.smtp_settings || Current.user.build_smtp_settings
        if @smtp_settings.update(smtp_settings_params)
            log_smtp_settings_successfully_changed
            redirect_to root_path, notice: 'SMTP настройките бяха ъпдейтнати успешно.'
        else
            log_smtp_settings_change_failed
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

    private

    def log_smtp_settings_view_opened
        if User.find_by(email: Current.user[:email])
            log_user_action(Current.user, "SMTP settings change opened", "User #{Current.user[:name]} opened the SMTP settings change menu")
        elsif Company.find_by(email: Current.user[:email])
            log_company_action(Current.user, "SMTP settings change opened", "Company #{Current.user[:name]} opened the SMTP settings change menu")
        end
    end

    def log_smtp_settings_successfully_changed
        if User.find_by(email: Current.user[:email])
            log_user_action(Current.user, "SMTP settings successfully changed", "User #{Current.user[:name]} successfully changed their SMTP settings")
        elsif Company.find_by(email: Current.user[:email])
            log_company_action(Current.user, "SMTP settings successfully changed", "Company #{Current.user[:name]} successfully changed their SMTP settings")
        end
    end

    def log_smtp_settings_change_failed
        if User.find_by(email: Current.user[:email])
            log_user_action(Current.user, "SMTP settings change failed", "User #{Current.user[:name]} failed to change their SMTP settings")
        elsif Company.find_by(email: Current.user[:email])
            log_company_action(Current.user, "SMTP settings change failed", "Company #{Current.user[:name]} failed to change their SMTP settings")
        end
    end
end