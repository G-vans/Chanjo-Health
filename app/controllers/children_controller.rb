class ChildrenController < ApplicationController
  before_action :set_child, only: %i[ show edit update destroy ]

  # GET /children or /children.json
  def index
    if params[:name].present?
      search_term = "%#{params[:name].downcase}%"
      @children = Child.where("lower(baby_name) LIKE ?", search_term)
    else
      @children = Child.all
    end
  end
  

  # GET /children/1 or /children/1.json
  def show
    @child = Child.find(params[:id])
    @baby_schedules = @child.immunization_schedules
  end

  # GET /children/new
  def new
    @child = Child.new
  end

  # GET /children/1/edit
  def edit
  end

  def update_status
    @child = Child.find(params[:child_id]) # Use child_id here
    @schedule = @child.immunization_schedules.find(params[:id]) # Use id for immunization_schedule
    if @schedule.update(status: true)
      flash[:notice] = "Immunization status updated successfully."
    else
      flash[:error] = "Failed to update immunization status."
    end
    redirect_to child_path(@child)
  end  
  

  # POST /children or /children.json
  def create
    @child = Child.new(child_params)

    respond_to do |format|
      if @child.save
        send_sms(@child)
        format.html { redirect_to child_url(@child), notice: "Child was successfully created." }
        format.json { render :show, status: :created, location: @child }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @child.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /children/1 or /children/1.json
  def update
    respond_to do |format|
      if @child.update(child_params)
        format.html { redirect_to child_url(@child), notice: "Child was successfully updated." }
        format.json { render :show, status: :ok, location: @child }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @child.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /children/1 or /children/1.json
  def destroy
    @child.destroy

    respond_to do |format|
      format.html { redirect_to children_url, notice: "Child was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_child
      @child = Child.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def child_params
      params.require(:child).permit(:baby_name, :parent_name, :date_of_birth, :gender, :phone_number)
    end

    def send_sms(child)
      # Set your app credentials
      # username = "valeria"
      #   apikey = "a91bf656d1ef72542dcbfe7b650e1263c08616ca9a71bf32f304699541cf86ce"
        username = "Gvans"
        apikey = "f19a53547997899dd02428a43499c58a3eb7a5c9aabbf3d1ea4e93d8bfc517ab"
      
        # Initialize the SDK
        @AT = AfricasTalking::Initialize.new(username, apikey)
      
        sms = @AT.sms
      # Retrieve the Current user's details from the database
  
      # to = child.phone_number
      
      baby = child.baby_name
      parent = child.parent_name
      to = child.phone_number
      
        # Send the welcome message
        message = "Welcome, #{parent}! Get ready for Chanjo, your ultimate immunization reminder app for your precious little one, #{baby}. We'll ensure you never miss a vaccination appointment. Stay tuned for regular reminders and keep your baby protected!"
        
        # Set your shortCode or senderId
        # from = "Vaxx-Alerts"
      
        options = {
          "to" => to,
          "message" => message
          # "from" => from
        }
      
        begin
          # Send the SMS and retrieve the response
          response = sms.send(options)
      
          # Log success or any necessary information
          Rails.logger.info "SMS sent successfully"
        rescue AfricasTalking::AfricasTalkingException => ex
          # Log error or any necessary information
          Rails.logger.error "Failed to send SMS: #{ex.message}"
        end
        
      end


    #send sms
    def send_welcome_sms(child)
      username = "Gvans"
      apikey = "f19a53547997899dd02428a43499c58a3eb7a5c9aabbf3d1ea4e93d8bfc517ab"
    
      # Initialize the SDK
      @AT = AfricasTalking::Initialize.new(username, apikey)
    
      sms = @AT.sms
    
      baby = child.baby_name
      parent = child.parent_name
      phone_number = child.phone_number
      to = "+#{phone_number}"
    
      # Send the welcome message
      welcome_message = "Welcome, #{parent}! Get ready for Chanjo, your ultimate immunization reminder app for your precious little one, #{baby}. We'll ensure you never miss a vaccination appointment. Stay tuned for regular reminders and keep your baby protected!"
      sends_sms(sms, to, welcome_message)
    
      # Send the next appointment message
      next_appointment_message = generate_next_appointment_message(child)
      sends_sms(sms, to, next_appointment_message)
    end
    
    def sends_sms(sms, to, message)
      # Set your shortCode or senderId
      # from = "Vaxx-Alerts"
    
      options = {
        "to" => to,
        "message" => message,
        # "from" => from
      }
    
      begin
        # Send the SMS and retrieve the response
        response = sms.send(options)
    
        # Log success or any necessary information
        Rails.logger.info "SMS sent successfully"
      rescue AfricasTalking::AfricasTalkingException => ex
        # Log error or any necessary information
        Rails.logger.error "Failed to send SMS: #{ex.message}"
      end
    end
    
    def generate_next_appointment_message(child)
      baby = child.baby_name
      parent = child.parent_name
      date_of_birth = child.date_of_birth
    
      # Calculate the next immunization date and days left
      next_immunization_date, days_left, immunization_name = calculate_next_immunization(child)
    
      if next_immunization_date && days_left && immunization_name
        return "Dear #{parent}, the next immunization for Baby #{baby} is on #{next_immunization_date}. There are #{days_left} days left. Remember this will be #{immunization_name}"
      else
        return "No upcoming immunizations scheduled for Baby #{baby}"
      end
    end
    
    def calculate_next_immunization(child)
      date_of_birth = child.date_of_birth
    
      if (date_of_birth + 6.weeks) > Date.today
        next_immunization_date = date_of_birth + 6.weeks
        days_left = (next_immunization_date - Date.today).to_i
        immunization_name = "2nd Oral polio vaccine; DPT, Hepatitis B and HIB; Pneumococcal vaccine (PCV 10); Rotavirus vaccine (Rotarix)"
      elsif (date_of_birth + 10.weeks) > Date.today
        next_immunization_date = date_of_birth + 10.weeks
        days_left = (next_immunization_date - Date.today).to_i
        immunization_name = "3rd Oral polio vaccine; DPT, Hepatitis B and HIB; Pneumococcal vaccine (PCV 10); Rotavirus vaccine (Rotarix)"
      elsif (date_of_birth + 14.weeks) > Date.today
        next_immunization_date = date_of_birth + 14.weeks
        days_left = (next_immunization_date - Date.today).to_i
        immunization_name = "4th Oral polio vaccine; DPT, Hepatitis B and HIB; Pneumococcal vaccine (PCV 10)"
      elsif (date_of_birth + 26.weeks) > Date.today
        next_immunization_date = date_of_birth + 26.weeks
        days_left = (next_immunization_date - Date.today).to_i
        immunization_name = "Measles vaccine, Vitamin A"
      elsif (date_of_birth + 39.weeks) > Date.today
        next_immunization_date = date_of_birth + 39.weeks
        days_left = (next_immunization_date - Date.today).to_i
        immunization_name = "Measles vaccine, Yellow Fever vaccine"
      end
    
      return next_immunization_date, days_left, immunization_name
    end
  
end
