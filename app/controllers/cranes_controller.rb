class CranesController < ApplicationController
  before_action :require_user_logged_in!
  before_action :set_crane, only: %i[ show edit update destroy ]

  # GET /cranes or /cranes.json
  def index
    @cranes = Crane.all
  end

  # GET /cranes/1 or /cranes/1.json
  def show
  end

  # GET /cranes/new
  def new
    @crane = Crane.new
  end

  # GET /cranes/1/edit
  def edit
  end

  # POST /cranes or /cranes.json
  def create
    @crane = Crane.new(crane_params)

    respond_to do |format|
      if @crane.save
        format.html { redirect_to crane_url(@crane), notice: "Crane was successfully created." }
        format.json { render :show, status: :created, location: @crane }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @crane.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cranes/1 or /cranes/1.json
  def update
    respond_to do |format|
      if @crane.update(crane_params)
        format.html { redirect_to crane_url(@crane), notice: "Crane was successfully updated." }
        format.json { render :show, status: :ok, location: @crane }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @crane.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cranes/1 or /cranes/1.json
  def destroy
    @crane.destroy

    respond_to do |format|
      format.html { redirect_to cranes_url, notice: "Crane was successfully destroyed." }
      format.json { head :no_content }
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
        :notes)
    end
end
