class CranesController < ApplicationController
  before_action :require_user_logged_in!
  before_action :set_crane, only: %i[ show edit update destroy ]

  # GET /cranes or /cranes.json
  def index
    @cranes = Crane.where(contractor_number: Current.user[:company_number])
    log_user_action(Current.user, 'assets check', "User #{Current.user[:name]} checked their cranes")
  end

  # GET /cranes/1 or /cranes/1.json
  def show
    log_user_action(Current.user, 'asset check', "User #{Current.user[:name]} checked crane with registration number #{@crane[:registration_number]}")
  end

  # GET /cranes/new
  def new
    @crane = Crane.new
    log_user_action(Current.user, 'new asset', "User #{Current.user[:name]} started creating new crane")
  end

  # GET /cranes/1/edit
  def edit
    log_user_action(Current.user, 'edit asset', "User #{Current.user[:name]} has started editing crane with registration number #{@crane[:registration_number]}")
  end

  # POST /cranes or /cranes.json
  def create
    @crane = Crane.new(crane_params)
    
    crane = Crane.find_by(registration_number: crane_params[:registration_number])
    if crane
      redirect_to new_crane_path, alert: "Вече съществува повдигателно съоръжение с този регистрационен номер!"
      log_user_action(Current.user, 'new asset exists', "User #{Current.user[:name]} tried to create crane with existing registration number #{crane[:registration_number]}")
      return
    end

    respond_to do |format|
      if @crane.save
        format.html { redirect_to crane_url(@crane), notice: "Успешно създаване на повдигателно съоръжение!" }
        format.json { render :show, status: :created, location: @crane }
        log_user_action(Current.user, 'new asset added', "User #{Current.user[:name]} created crane with registration number #{@crane[:registration_number]}")
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @crane.errors, status: :unprocessable_entity }
        log_user_action(Current.user, 'new asset failed to add', "User #{Current.user[:name]} couldn't create crane with registration number #{@crane[:registration_number]}")
      end
    end
  end

  # PATCH/PUT /cranes/1 or /cranes/1.json
  def update
    respond_to do |format|
      if @crane.update(crane_params)
        format.html { redirect_to crane_url(@crane), notice: "Успешно редактиране на повдигателно съоръжение!" }
        format.json { render :show, status: :ok, location: @crane }
        log_user_action(Current.user, 'update asset', "User #{Current.user[:name]} updated crane with registration number #{@crane[:registration_number]}")
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @crane.errors, status: :unprocessable_entity }
        log_user_action(Current.user, 'asset update failed', "User #{Current.user[:name]} couldn't update crane with registration number #{@crane[:registration_number]}")
      end
    end
  end

  # DELETE /cranes/1 or /cranes/1.json
  def destroy
    @crane.destroy

    respond_to do |format|
      format.html { redirect_to cranes_url, notice: "Успешно премахване на повдигателно съоръжение!" }
      format.json { head :no_content }
      log_user_action(Current.user, 'asset deleted', "User #{Current.user[:name]} deleted crane with registration number #{@crane[:registration_number]}")
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_crane
      @crane = Crane.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def crane_params
      params.require(:crane).permit(
        :status, 
        :crane_type, 
        :load_capacity,
        :year_of_manufacture,
        :application_number,
        :application_date,
        :registration_date,
        :last_check_date,
        :next_check_date,
        :suspension_date,
        :scrap_date,
        :user,
        :user_address,
        :manufacturer,
        :location,
        :serial_number,
        :registration_number,
        :notes).merge(contractor_number: Current.user[:company_number])
    end
end
