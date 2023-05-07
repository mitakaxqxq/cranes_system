class HomeController < ApplicationController
  before_action :require_user_logged_in!, only: [:about]

  def index
  end

  def about
    if User.find_by(email: Current.user[:email])
      log_user_action(Current.user, "documentation check", "User #{Current.user[:name]} opened the documentation")
    elsif Company.find_by(email: Current.user[:email])
      log_company_action(Current.user, "documentation check", "Company #{Current.user[:name]} opened the documentation")
    end
  end

end
