class SessionsController < ApplicationController
    def new
    
    end
    
    def create
        user = User.find_by(email: params[:email])
        company = Company.find_by(email: params[:email])
        if user.present? && user.authenticate(params[:password])
            session[:user_id] = user.id
            redirect_to root_path, :flash => { :notice => 'Успешен вход!' }
        elsif company.present? && company.authenticate(params[:password])
            session[:company_id] = company.id
            redirect_to root_path, :flash => { :notice => 'Успешен вход!' }
        else
            redirect_to sign_in_path, :flash => { :alert => 'Невалиден имейл или парола!' }
        end
    end
    
    def destroy
        if session[:user_id]
            session[:user_id] = nil
        else
            session[:company_id] = nil
        end
        redirect_to root_path, :flash => { :notice => 'Успешен изход!' }
    end
end
