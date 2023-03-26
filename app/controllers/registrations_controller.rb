class RegistrationsController < ApplicationController
    def new
    end

    def new_user
        @user = User.new
    end

    def create_user
        @user = User.new(user_params)
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
end