class PasswordsController < ApplicationController
    before_action :require_user_logged_in!

    def edit
        log_edit_view_opened
    end

    def update
        @user = User.find_by(email: Current.user[:email])
        @company = Company.find_by(email: Current.user[:email])
        if Current.user.update(password_params)
            log_successful_password_change
            redirect_to root_path, :flash => { :notice => 'Успешна промяна на парола!' }
        else
            log_unsuccessful_password_change
            redirect_to edit_password_path, :flash => { :alert => 'Паролите не съвпадат!' }
        end
    end

    private

    def password_params
        if @user.present?
            params.require(:user).permit(:password, :password_confirmation)
        elsif @company.present?
            params.require(:company).permit(:password, :password_confirmation)
        end
    end

    def log_edit_view_opened
        if User.find_by(email: Current.user[:email])
            log_user_action(Current.user, "password change opened", "User #{Current.user[:name]} opened the password change menu")
        elsif Company.find_by(email: Current.user[:email])
            log_company_action(Current.user, "password change opened", "Company #{Current.user[:name]} opened the password change menu")
        end
    end

    def log_successful_password_change
        if User.find_by(email: Current.user[:email])
            log_user_action(Current.user, "password changed", "User #{Current.user[:name]} successfully changed their password")
        elsif Company.find_by(email: Current.user[:email])
            log_company_action(Current.user, "password changed", "Company #{Current.user[:name]} successfully changed their password")
        end
    end

    def log_unsuccessful_password_change
        if User.find_by(email: Current.user[:email])
            log_user_action(Current.user, "password change failed", "User #{Current.user[:name]} failed to change their password")
        elsif Company.find_by(email: Current.user[:email])
            log_company_action(Current.user, "password change failed", "Company #{Current.user[:name]} failed to change their password")
        end
    end
end
