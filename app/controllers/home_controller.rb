class HomeController < ApplicationController
  before_action :require_user_logged_in!, only: [:about_user, :about_company]

  def index
  end

  def about_user
    log_user_action(Current.user, "documentation check", "User #{Current.user[:name]} opened the documentation")
  end

  def about_company
    log_company_action(Current.user, "documentation check", "Company #{Current.user[:name]} opened the documentation")
  end

end
