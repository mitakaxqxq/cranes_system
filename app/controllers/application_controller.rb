class ApplicationController < ActionController::Base
    before_action :set_current_user

    def set_current_user
        if session[:user_id]
            Current.user = User.find_by(id: session[:user_id])
        elsif session[:company_id]
            Current.user = Company.find_by(id: session[:company_id])
        end
    end

    def require_user_logged_in!
        if Current.user.nil?
            redirect_to sign_in_path, :flash => { :alert => 'Трябва да сте влезли в системата за това действие!' }
        end
    end
end
