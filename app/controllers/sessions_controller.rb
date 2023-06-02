class SessionsController < ApplicationController
    def new
    end
    
    def create
        user = User.find_by(email: params[:email])
        company = Company.find_by(email: params[:email])
        if user.present? && user.authenticate(params[:password])
            session[:user_id] = user.id
            log_user_action(user, "logged in", "User with email #{params[:email]} logged in")
            redirect_to root_path, :flash => { :notice => 'Успешен вход!' }
        elsif company.present? && company.authenticate(params[:password])
            session[:company_id] = company.id
            log_company_action(company, "logged in", "Company with email #{params[:email]} logged in")
            redirect_to root_path, :flash => { :notice => 'Успешен вход!' }
        else
            log_company_action(nil, "login attempt fail", "Someone tried to login with email #{params[:email]}")
            redirect_to sign_in_path, :flash => { :alert => 'Невалиден имейл или парола!' }
        end
    end
    
    def destroy
        if session[:user_id]
            user = User.find_by(id: session[:user_id])
            log_user_action(user, "logged out", "User with email #{user[:email]} logged out")
            session[:user_id] = nil
        else
            company = Company.find_by(id: session[:company_id])
            log_company_action(company, "logged out", "Company with email #{company[:email]} logged out")
            session[:company_id] = nil
        end
        redirect_to root_path, :flash => { :notice => 'Успешен изход!' }
    end
end
