class CompanyContractorsController < ApplicationController
  before_action :require_user_logged_in!

  def index
    @company_contractors = Current.user.company_contractors
    log_user_action(Current.user, 'contractors check', "User #{Current.user[:name]} checked the Companies they are working for as contractors")
  end
end