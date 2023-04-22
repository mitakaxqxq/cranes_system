class CompaniesController < ApplicationController
  before_action :require_user_logged_in!
  before_action :set_contractors
  before_action :set_company, only: %i[ show ]

  def add_contractors
    contractor_id = params[:contractor_number]
    user = User.find_by(company_number: contractor_id)

    if user.present?
      company_contractor = CompanyContractor.find_by(company_id: Current.user.id, user_id: user.id)
      if company_contractor
        redirect_to company_check_contractors_path, alert: "Органът за технически надзор вече работи за Вас."
        return
      end

      company_contractor = CompanyContractor.create(company_id: Current.user.id, user_id: user.id)

      if company_contractor.persisted?
        redirect_to company_check_contractors_path, notice: "Органът за технически надзор е добавен успешно."
      end
    else
      redirect_to company_check_contractors_path, alert: "Органът за технически надзор не съществува!"
    end
  end

  def view_contractors
  end

  def view_contractor_cranes
    @user = User.find_by(company_number: params[:contractor_number])
    @cranes = Crane.where("registration_number LIKE :prefix", prefix: "#{params[:contractor_number]}%")
  end

  def edit_contractors
  end

  def destroy_contractor
    user = User.find_by(id: params[:contractor_id])
    company_contractor = Current.user.company_contractors.find_by(user_id: user.id)
    if company_contractor.destroy
      redirect_to company_check_contractors_path, notice: "Органът за технически надзор е премахнат успешно."
    else
      redirect_to company_check_contractors_path, alert: "Органът за технически надзор не може да се премахне."
    end
  end

  private
    def set_company
      @company = Company.find(Current.user[:id])
    end

    def set_contractors
      @contractors = Current.user.company_contractors.map(&:user)
    end

end
