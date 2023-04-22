class CompanyContractorsController < ApplicationController
  before_action :require_user_logged_in!

  def index
    @company_contractors = Current.user.company_contractors
  end
end