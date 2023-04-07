class RegistrationsController < ApplicationController
    def new
    end

    def new_user
        @user = User.new
    end

    def create_user
        @user = User.new(user_params)
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
            redirect_to root_path, :flash => { :notice => 'Успешна регистрация!' }
        else
            render :new
        end
    end

    def new_company
        @company = Company.new
    end

    def create_company
        @company = Company.new(company_params)
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
            redirect_to root_path, :flash => { :notice => 'Успешна регистрация!' }
        else
            render :new
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