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

    private

    def log_user_action(user, action, message)
        user_agent = UserAgent.parse(request.user_agent)
        browser_name = user_agent.browser
        browser_version = user_agent.version.to_s

        logging = Logging.new(
            user_id: user.id,
            action: action,
            message: message,
            url: request.original_url,
            browser: "#{browser_name} #{browser_version}",
            executed_at: Time.current
        )

        if logging.save
            # Successfully logged
        else
            puts logging.errors.full_messages
        end
    end

    def log_company_action(company, action, message)
        user_agent = UserAgent.parse(request.user_agent)
        browser_name = user_agent.browser
        browser_version = user_agent.version.to_s

        logging = Logging.new(
            company_id: company.id,
            action: action,
            message: message,
            url: request.original_url,
            browser: "#{browser_name} #{browser_version}",
            executed_at: Time.current
        )

        if logging.save
            # Successfully logged
        else
            puts logging.errors.full_messages
        end
    end

    
end
