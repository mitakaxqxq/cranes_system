class HomeController < ApplicationController
  before_action :require_user_logged_in!, only: [:about]

  def index
  end

  def about
  end

end
