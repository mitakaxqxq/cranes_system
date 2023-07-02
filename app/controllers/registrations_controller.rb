class RegistrationsController < ApplicationController
    def new
    end

    def new_user
        @user = User.new
    end

    def create_user
        @user = User.new(user_params)
        email_regex = /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
        
        if @user[:name].nil? || @user[:email].nil? || @user[:password_digest].nil? || @user[:company_number].nil?
            redirect_to user_sign_up_path, :flash => { :alert => 'Всички полета са задължителни! Моля, въведете пълната информация!' }
            return
        end
        unless @user[:email].match?(email_regex)
            redirect_to user_sign_up_path, :flash => { :alert => 'Имейлът не е в правилен формат!' }
            return
        end
        if user_with_email_exists?(@user)
            redirect_to user_sign_up_path, :flash => { :alert => 'Вече съществува орган за технически надзор с този имейл!' }
            return
        end
        if user_with_company_number_exists?(@user)
            redirect_to user_sign_up_path, :flash => { :alert => 'Вече съществува орган за технически надзор с този номер на компанията!' }
            return
        end

        if @user.save
            session[:user_id] = @user.id
            log_user_action(@user, "successful registration", "User with email #{@user[:email]} registered")
            redirect_to root_path, :flash => { :notice => 'Успешна регистрация!' }
        else
            log_user_action(@user, "unsuccessful registration", "User with email #{@user[:email]} tried to register but failed")
            puts @user.errors.full_messages.join(", ")
        end
    end

    def new_company
        @company = Company.new
    end

    def create_company
        @company = Company.new(company_params)
        email_regex = /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
        
        if @company[:name].nil? || @company[:email].nil? || @company[:password_digest].nil? || @company[:uic].nil?
            redirect_to company_sign_up_path, :flash => { :alert => 'Всички полета са задължителни! Моля, въведете пълната информация!' }
            return
        end
        unless @company[:email].match?(email_regex)
            redirect_to company_sign_up_path, :flash => { :alert => 'Имейлът не е в правилен формат!' }
            return
        end
        unless @company[:uic].is_a?(Integer) && @company[:uic].respond_to?(:to_s) && @company[:uic].to_s.length == 9
            redirect_to company_sign_up_path, :flash => { :alert => 'ЕИК трябва да е цяло число с 9 цифри!' }
            return
        end
        if company_with_email_exists?(@company)
            redirect_to company_sign_up_path, :flash => { :alert => 'Вече съществува компания с този имейл!' }
            return
        end
        if company_with_uic_exists?(@company)
            redirect_to company_sign_up_path, :flash => { :alert => 'Вече съществува компания с този ЕИК!' }
            return
        end

        if @company.save
            session[:company_id] = @company.id
            log_company_action(@company, "successful registration", "Company with email #{@company[:email]} registered")
            redirect_to root_path, :flash => { :notice => 'Успешна регистрация!' }
        else
            log_company_action(@company, "unsuccessful registration", "Company with email #{@company[:email]} tried to register but failed")
            puts @company.errors.full_messages.join(", ")
        end
    end

    private

    def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation, :company_number)
    end

    def company_params
        params.require(:company).permit(:email, :password, :password_confirmation, :uic, :name, :address)
    end

    def user_with_email_exists?(user)
        if User.find_by(email: user[:email])
            return true
        end
        return false
    end

    def user_with_company_number_exists?(user)
        if User.find_by(company_number: user[:company_number])
            return true
        end
        return false
    end

    def company_with_email_exists?(company)
        if Company.find_by(email: company[:email])
            return true
        end
        return false
    end

    def company_with_uic_exists?(company)
        if Company.find_by(uic: company[:uic])
            return true
        end
        return false
    end
end