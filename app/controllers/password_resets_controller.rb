class PasswordResetsController < ApplicationController
    def new
    end

    def create
        @user = User.find_by(email: params[:email])
        @company = Company.find_by(email: params[:email])

        if @user.present?
            PasswordMailer.with(user: @user).reset.deliver_now
            log_user_action(@user, "user sent password reset", "Email #{@user[:email]} has been sent a password reset link.")
        elsif @company.present?
            PasswordMailer.with(company: @company).reset.deliver_now
            log_company_action(@company, "company sent password reset", "Email #{@company[:email]} has been sent a password reset link.")
        end
        redirect_to root_path, :flash => { :notice => 'Изпратен е линк за промяна на паролата до посочения имейл адрес.' }
    end

    def edit
        begin
            @user = User.find_signed!(params[:token], purpose: 'password_reset')
        rescue ActiveSupport::MessageVerifier::InvalidSignature
            begin
              @company = Company.find_signed!(params[:token], purpose: 'password_reset')
            rescue ActiveSupport::MessageVerifier::InvalidSignature
              redirect_to password_reset_path, :flash => { :alert => 'Имейл токенът е изтекъл! Моля, направете нова заявка.' }
              return
            end
        end
    end

    def update
        begin
            @user = User.find_signed!(params[:token], purpose: 'password_reset')
        rescue ActiveSupport::MessageVerifier::InvalidSignature
            begin
                @company = Company.find_signed!(params[:token], purpose: 'password_reset')
            rescue ActiveSupport::MessageVerifier::InvalidSignature
                redirect_to password_reset_path, :flash => { :alert => 'Имейл токенът е изтекъл! Моля, направете нова заявка.' }
                return
            end

            if @company.update(password_params)
                log_company_action(@company, 'company password reset', "Company with email #{@company[:email]} has reset their password.")
                redirect_to sign_in_path, :flash => { :notice => 'Паролата Ви беше променена успешно. Моля, влезте в системата.' }
            else
                render :edit
            end
        end

        if @user.present?
            if @user.update(password_params)
                log_user_action(@user, 'user password reset', "User with email #{@user[:email]} has reset their password.")
                redirect_to sign_in_path, :flash => { :notice => 'Паролата Ви беше променена успешно. Моля, влезте в системата.' }
            end
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
end