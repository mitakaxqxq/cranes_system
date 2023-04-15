class CompaniesController < ApplicationController
  before_action :require_user_logged_in!
  before_action :set_company, only: %i[ show ]

  # GET /companies/1 or /companies/1.json
  def show
  end

  def add_contractors
    contractor_id = params[:contractor_number]
    if User.find_by(company_number: contractor_id)
      if Current.user[:contractors].include?(contractor_id)
        redirect_to edit_contractors_path, alert: "Органът за технически надзор вече работи за Вас."
      else
        Current.user[:contractors] << contractor_id
        redirect_to edit_contractors_path, notice: "Органът за технически надзор е добавен успешно."
      end
    else
      redirect_to edit_contractors_path, alert: "Органът за технически надзор не съществува!"
    end
    Current.user.save
  end

  def view_contractors
  end

  def view_contractor_cranes
    @user = User.find_by(company_number: params[:contractor_number])
    @cranes = Crane.where("registration_number LIKE :prefix", prefix: "#{params[:contractor_number]}%")
  end

  def edit_contractors
    @contractor_number = params[:contractor_number]

    if @contractor_number.present?
      if Current.user.contractors.include?(@contractor_number)
        flash[:notice] = "Органът за технически надзор вече е добавен."
      else
        Current.user.contractors << @contractor_number
        flash[:notice] = "Органът за технически надзор е добавен успешно."
      end

      redirect_to company_check_contractors_path
    end
  end


  def update_contractors
    if @company.save
      redirect_to company_check_contractors_path, notice: 'Contractors updated successfully!'
    else
      render :edit_contractors
    end
  end

  def destroy_contractor
    contractor_number = params[:contractor_number]
    if Current.user[:contractors].delete(contractor_number)
      Current.user.save
      redirect_to company_check_contractors_path, notice: "Органът за технически надзор е премахнат успешно."
    else
      redirect_to company_check_contractors_path, alert: "Органът за технически надзор не може да се премахне."
    end
  end

  private
    def set_company
      @company = Company.find(Current.user[:id])
    end
end
