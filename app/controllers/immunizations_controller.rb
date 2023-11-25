class ImmunizationsController < ApplicationController
  before_action :authenticate_medic!, :set_immunization, only: %i[ show edit update destroy ]

  # GET /immunizations or /immunizations.json
  def index
    @immunizations = Immunization.all
  end

  # GET /immunizations/1 or /immunizations/1.json
  def show
  end

  # GET /immunizations/new
  def new
    @child = Child.find(params[:child_id])
    @immunization = @child.immunizations.build
  end  

  # GET /immunizations/1/edit
  def edit
  end

  # POST /immunizations
  def create
    @immunization = Immunization.new(immunization_params)
    @immunization.medic_id = current_medic.id
    respond_to do |format|
      if @immunization.save
        send_immunization_sms(@immunization)
        send_next_appointment_sms(@immunization)
        format.html { redirect_to immunizations_url, notice: "Immunization was successfully created." }
        format.json { render :show, status: :created, location: @immunization }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @immunization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /immunizations/1 
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
      format.html { redirect_to immunizations_path, notice: "Immunization was successfully destroyed." }
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
    #send_sms
    def send_immunization_sms(immunization)
      username = "sandbox"
      apikey = "0c82c2ffbd7cd569f67e9ab81805df6f5f1a3aa02e32d4bef165715575082316"
    
      # Initialize the SDK
      @AT = AfricasTalking::Initialize.new(username, apikey)
    
      sms = @AT.sms
      # Retrieve the child's details
      child = immunization.child
      baby = child.baby_name
      parent = child.parent_name
      phone_number = child.phone_number
      to = "+#{phone_number}"
      message = "Dear #{parent}, the immunization #{immunization.vax_name} has been given to Baby #{baby}."
  
      # Set your shortCode or senderId
      from = "Vaxx-Alerts"
  
      options = {
        "to" => to,
        "message" => message,
        "from" => from
      }
  
      # Send the SMS and retrieve the response
      sms.send(options)
  
      Rails.logger.info "Immunization SMS sent successfully"
    rescue AfricasTalking::AfricasTalkingException => ex
      Rails.logger.error "Failed to send immunization SMS: #{ex.message}"
    end
  
    def send_next_appointment_sms(immunization)
      username = "sandbox"
      apikey = "0c82c2ffbd7cd569f67e9ab81805df6f5f1a3aa02e32d4bef165715575082316"
    
      # Initialize the SDK
      @AT = AfricasTalking::Initialize.new(username, apikey)
    
      sms = @AT.sms
      # Retrieve the child's details
      child = immunization.child
      baby = child.baby_name
      parent = child.parent_name
      phone_number = child.phone_number
      to = "+#{phone_number}"
      date_given = immunization.date
  
      next_immunization_date = nil
      days_left = nil
  
      case immunization.vax_name
      when "2nd Oral polio vaccine; DPT, Hepatitis B and HIB; Pneumococcal vaccine (PCV 10); Rotavirus vaccine (Rotarix)"
        next_immunization_date = date_given + 4.weeks
        days_left = (next_immunization_date - Date.today).to_i
      when "3rd Oral polio vaccine; DPT, Hepatitis B and HIB; Pneumococcal vaccine (PCV 10); Rotavirus vaccine (Rotarix)"
        next_immunization_date = date_given + 10.weeks
        days_left = (next_immunization_date - Date.today).to_i
      when "4th Oral polio vaccine; DPT, Hepatitis B and HIB; Pneumococcal vaccine (PCV 10)"
        next_immunization_date = date_given + 14.weeks
        days_left = (next_immunization_date - Date.today).to_i
      when "Measles vaccine, Vitamin A"
        next_immunization_date = date_given + 26.weeks
        days_left = (next_immunization_date - Date.today).to_i
      when "Measles vaccine, Yellow Fever vaccine"
        next_immunization_date = date_given + 39.weeks
        days_left = (next_immunization_date - Date.today).to_i
      end
  
      if next_immunization_date && days_left
        message = "Dear #{parent}, the next immunization for Baby #{baby} is scheduled on #{next_immunization_date}. There are #{days_left} days left."
  
        # Set your shortCode or senderId
        from = "Vaxx-Alerts"
  
        options = {
          "to" => to,
          "message" => message,
          "from" => from
        }
  
        # Send the SMS and retrieve the response
        sms.send(options)
  
        Rails.logger.info "Next Appointment SMS sent successfully"
      else
        Rails.logger.error "Failed to calculate next appointment date"
      end
    rescue AfricasTalking::AfricasTalkingException => ex
      Rails.logger.error "Failed to send next appointment SMS: #{ex.message}"
    end
end
