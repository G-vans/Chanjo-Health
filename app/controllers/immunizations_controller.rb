class ImmunizationsController < ApplicationController
  before_action :set_immunization, only: %i[ show edit update destroy ]

  # GET /immunizations or /immunizations.json
  def index
    @immunizations = Immunization.all
  end

  # GET /immunizations/1 or /immunizations/1.json
  def show
  end

  # GET /immunizations/new
  def new
    @immunization = Immunization.new
  end

  # GET /immunizations/1/edit
  def edit
  end

  # POST /immunizations or /immunizations.json
  def create
    @immunization = Immunization.new(immunization_params)

    respond_to do |format|
      if @immunization.save
        format.html { redirect_to immunization_url(@immunization), notice: "Immunization was successfully created." }
        format.json { render :show, status: :created, location: @immunization }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @immunization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /immunizations/1 or /immunizations/1.json
  def update
    respond_to do |format|
      if @immunization.update(immunization_params)
        format.html { redirect_to immunization_url(@immunization), notice: "Immunization was successfully updated." }
        format.json { render :show, status: :ok, location: @immunization }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @immunization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /immunizations/1 or /immunizations/1.json
  def destroy
    @immunization.destroy

    respond_to do |format|
      format.html { redirect_to immunizations_url, notice: "Immunization was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_immunization
      @immunization = Immunization.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def immunization_params
      params.require(:immunization).permit(:vax_name, :date, :child_id, :medic_id)
    end
end
