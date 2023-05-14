class CompaniesController < ApplicationController
  before_action :require_user_logged_in!
  before_action :set_contractors
  before_action :set_company, only: %i[ show ]

  def add_contractors
    contractor_number = params[:contractor_number]
    user = User.find_by(company_number: contractor_number)

    if user.present?
      company_contractor = CompanyContractor.find_by(company_id: Current.user.id, user_id: user.id)
      if company_contractor
        log_company_already_has_contractor(contractor_number)
        redirect_to company_check_contractors_path, alert: "Органът за технически надзор вече работи за Вас."
        return
      end

      company_contractor = CompanyContractor.create(company_id: Current.user.id, user_id: user.id)

      if company_contractor.persisted?
        log_company_successfully_added_contractor(contractor_number)
        redirect_to company_check_contractors_path, notice: "Органът за технически надзор е добавен успешно."
      end
    else
      log_company_add_contractor_failed(contractor_number)
      redirect_to company_check_contractors_path, alert: "Органът за технически надзор не съществува!"
    end
  end

  def view_contractors
    log_company_view_contractors
  end

  def view_contractor_cranes
    @user = User.find_by(company_number: params[:contractor_number])
    @cranes = Crane.where("contractor_number = :number AND user = :user", number: params[:contractor_number].to_i, user: Current.user[:name])
    log_company_view_contractor_cranes(params[:contractor_number])
  end

  def edit_contractors
  end

  def destroy_contractor
    user = User.find_by(id: params[:contractor_id])
    company_contractor = Current.user.company_contractors.find_by(user_id: user.id)
    if company_contractor.destroy
      log_company_successfully_removed_contractor(user[:company_number])
      redirect_to company_check_contractors_path, notice: "Органът за технически надзор е премахнат успешно."
    else
      log_company_remove_contractor_failed(user[:company_number])
      redirect_to company_check_contractors_path, alert: "Органът за технически надзор не може да се премахне."
    end
  end

  private

  def set_company
    @company = Company.find(Current.user[:id])
    log_company_action(Current.user, 'company info check', "Company #{Current.user[:name]} checked their info")
  end

  def set_contractors
    @contractors = Current.user.company_contractors.map(&:user)
  end

  def log_company_view_contractors
    log_company_action(Current.user, 'view assets', "Company #{Current.user[:name]} checked their contractors")
  end

  def log_company_view_contractor_cranes(contractor_number)
    log_company_action(Current.user, 'view assets', "Company #{Current.user[:name]} checked contractor with number #{contractor_number}'s cranes")
  end

  def log_company_already_has_contractor(contractor_number)
    log_company_action(Current.user, 'add asset', "Company #{Current.user[:name]} tried to add contractor with number #{contractor_number} who are already working for them")
  end

  def log_company_successfully_added_contractor(contractor_number)
    log_company_action(Current.user, 'add asset success', "Company #{Current.user[:name]} successfully added a contractor with number #{contractor_number}")
  end

  def log_company_add_contractor_failed(contractor_number)
    log_company_action(Current.user, 'add asset fail', "Company #{Current.user[:name]} failed to add contractor with number #{contractor_number}")
  end

  def log_company_successfully_removed_contractor(contractor_number)
    log_company_action(Current.user, 'remove asset success', "Company #{Current.user[:name]} successfully removed contractor with number #{contractor_number}")
  end

  def log_company_remove_contractor_failed(contractor_number)
    log_company_action(Current.user, 'remove asset fail', "Company #{Current.user[:name]} failed to remove contractor with number #{contractor_number}")
  end

end
