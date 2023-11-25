class ImmunizationSchedulesController < ApplicationController
  before_action :authenticate_medic!, :set_immunization_schedule, only: %i[ show edit update destroy ]

  # GET /immunization_schedules or /immunization_schedules.json
  def index
    if params[:name].present?
      search_term = "%#{params[:name].downcase}%"
      @immunization_schedules = ImmunizationSchedule.joins(:child).where("lower(children.baby_name) LIKE ?", search_term)
    else
      @immunization_schedules = ImmunizationSchedule.all
    end
  end
  

  # GET /immunization_schedules/1 or /immunization_schedules/1.json
  def show
    @immunization_schedule = ImmunizationSchedule.find(params[:id])
    @child = @immunization_schedule.child # Load the associated child
  end  

  def new
    @child = Child.find(params[:child_id])
    @immunization_schedule = @child.immunization_schedules.build
  end

  def update_status
  @schedule = ImmunizationSchedule.find(params[:id])
  @schedule.update(status: true) # Mark the immunization as taken
  flash[:notice] = "Immunization status updated successfully."
  redirect_to @schedule.child # Redirect back to the child's page or wherever you want
end


  # GET /immunization_schedules/new
  # def new
  #   @immunization_schedule = ImmunizationSchedule.new
  # end

  # GET /immunization_schedules/1/edit
  def edit
  end

  # POST /immunization_schedules 
  def create
    @immunization_schedule = ImmunizationSchedule.new(immunization_schedule_params)
    @immunization_schedule.medic_id = current_medic.id
    respond_to do |format|
      if @immunization_schedule.save
        format.html { redirect_to immunization_schedule_url(@immunization_schedule), notice: "Immunization schedule was successfully created." }
        format.json { render :show, status: :created, location: @immunization_schedule }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @immunization_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /immunization_schedules/1 
  def update
    respond_to do |format|
      if @immunization_schedule.update(immunization_schedule_params)
        format.html { redirect_to immunization_schedule_url(@immunization_schedule), notice: "Immunization schedule was successfully updated." }
        format.json { render :show, status: :ok, location: @immunization_schedule }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @immunization_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /immunization_schedules/1 or /immunization_schedules/1.json
  def destroy
    @immunization_schedule.destroy

    respond_to do |format|
      format.html { redirect_to immunization_schedules_url, notice: "Immunization schedule was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  #Radisys follow up

  require 'net/http'
require 'uri'
require 'json'

def follow_up_call
  account_id = 'AC-1da9836d-57f4-4723-98cf-de2744fb27ae'
  url = URI.parse("https://apigateway.engagedigital.ai/api/v1/accounts/#{account_id}/call")
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true

  api_key = 'eyJ4NXQiOiJZamd5TW1GalkyRXpNVEZtWTJNMU9HRmtaalV3TnpnMVpEVmhZVGRtTnpkaU9HUmhNR1kzWmc9PSIsImtpZCI6ImFwaV9rZXlfY2VydGlmaWNhdGVfYWxpYXMiLCJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJyYWRpc3lzQGNhcmJvbi5zdXBlciIsImFwcGxpY2F0aW9uIjp7Im93bmVyIjoicmFkaXN5cyIsInRpZXJRdW90YVR5cGUiOm51bGwsInRpZXIiOiJVbmxpbWl0ZWQiLCJuYW1lIjoicnN5cy0xMDA3Ni10YWRoYWNrMjMuY29tIiwiaWQiOjI4NywidXVpZCI6IjY2NDlhNjYzLTVmZmQtNDUxMS1hMGI3LTg4ODBjODcyOTY5YiJ9LCJpc3MiOiJodHRwczpcL1wvYXBpbS5lbmdhZ2VkaWdpdGFsLmFpOjQ0M1wvb2F1dGgyXC90b2tlbiIsInRpZXJJbmZvIjp7IlVubGltaXRlZCI6eyJ0aWVyUXVvdGFUeXBlIjoicmVxdWVzdENvdW50Iiwic3RvcE9uUXVvdGFSZWFjaCI6dHJ1ZSwic3Bpa2VBcnJlc3RMaW1pdCI6MCwic3Bpa2VBcnJlc3RVbml0IjpudWxsfX0sImtleXR5cGUiOiJQUk9EVUNUSU9OIiwic3Vic2NyaWJlZEFQSXMiOlt7InN1YnNjcmliZXJUZW5hbnREb21haW4iOiJjYXJib24uc3VwZXIiLCJuYW1lIjoiQ2FsbEFQSVByb2R1Y3QiLCJjb250ZXh0IjoiXC9hcGlcL3YxIiwicHVibGlzaGVyIjoicmFkaXN5cyIsInZlcnNpb24iOiIxLjAuMCIsInN1YnNjcmlwdGlvblRpZXIiOiJVbmxpbWl0ZWQifSx7InN1YnNjcmliZXJUZW5hbnREb21haW4iOiJjYXJib24uc3VwZXIiLCJuYW1lIjoiU2VydmljZUFQSVByb2R1Y3QiLCJjb250ZXh0IjoiXC9hcGkiLCJwdWJsaXNoZXIiOiJyYWRpc3lzIiwidmVyc2lvbiI6IjEuMC4wIiwic3Vic2NyaXB0aW9uVGllciI6IlVubGltaXRlZCJ9XSwiaWF0IjoxNjk3NzkyMzU3LCJqdGkiOiJiNmRlZmMzOC1jZWJmLTRkYTgtYTUwNS04OTU0OGUzMmUwNzAifQ==.SW1xY1jSfme5PPlKsIsGPEchpzL3gZVLycNPNSNYzHACcbcUdQh10QiqdgFag-EUejG_323bVwvArabvCmqPv7uaP-ShWmbWpHavPFRRY61mbKg51v0SU3xkOWhGDeON0Q5EZWfi31HtRJ2bLtVbZs6p1ajTttqCkmlgYZTzSJ9WqbnANfO41XIHT0kkV-t9cN-mWIc0aJsTTm3mMRI4eL9mQFzZwb--31s5SWbso-YDGW9L-IIZdA89uQxPYoQHNm5fGWCH-zuED0Sj00eG8HI9fZqAK6YIYKfk_Myun87UYh9Zbkzo9BDYeTiM8_jQ0ykLSOqBp7pQ6ggoZ1iOCw=='

  request = Net::HTTP::Post.new(url.path, 'Content-Type' => 'application/json')
  request['apikey'] = api_key

  require 'nokogiri'

  # child = Child.find(params[:child_id])
  # @immuni = ImmunizationSchedule.find(params[:immunization_schedule_id])
  
  #   # Retrieve child details
  #   # baby = child.baby_name
  #   parent = @immuni.child_id.parent_name

# Create an EML XML document
builder = Nokogiri::XML::Builder.new do |xml|
  xml.Response do
    xml.Say "Good day, Jevans! This is a friendly reminder regarding your baby's missed immunization. We kindly request you to visit the nearest Nairobi Hospital branch for your baby's overdue vaccination. Thank you and have a good day!"
  end
end

# Get the XML string from the builder
eml_xml = builder.to_xml

# Now you can use the eml_xml in your payload
payload = {
  "From" => "800698",
  "To" => "sip:8008056@sipaz1.engageio.com",
  # "ApplicationID": "VDT-ID",
  "Eml" => eml_xml,
  "StatusCallbackMethod" => "POST",
  "StatusCallbackEvent" => "initiated, ringing, answered, completed",
  "Type": "voice",
  "Bridge": "none"
}


  request.body = payload.to_json

  response = http.request(request)

  puts "Response: #{response.code} #{response.message}"
  puts response.body
end
  #close

  def send_sms
    # Set your app credentials
    username = "sandbox"
    apikey = "421aadbc7b715edab833809471b084fc1a409aa811e7af3b1e5ab79cc551549f"
  
    # Initialize the SDK
    @AT = AfricasTalking::Initialize.new(username, apikey)
  
    # Get the SMS service
    sms = @AT.sms
  
    # Retrieve the phone number from the input field
    #to = params[:phone_number]
    #to = "+254727538865"
  
    # Retrieve the child's details from the database using the current child ID
    child = Child.find(params[:child_id])
  
    # Retrieve child details
    baby = child.baby_name
    parent = child.parent_name
    #to = "+254" + child.phone_number[1..-1]
    to = "+#{child.phone_number}"
  
  
      message = "Dear #{parent}, this is a follow up on the missed immunization schedule for Baby #{baby}. We would like to remind you again on this."
      flash[:notice] = "Message sent successfully"
  
    # Set your shortCode or senderId
    from = "Vaxx-Alerts"
  
    options = {
      "to" => to,
      "message" => message,
      "from" => from
    }
  
    begin
      # Send the SMS and retrieve the response
      response = sms.send(options)
  
      # Render the response as JSON
      render json: response
    rescue AfricasTalking::AfricasTalkingException => ex
      render json: { error: ex.message }, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_immunization_schedule
      @immunization_schedule = ImmunizationSchedule.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def immunization_schedule_params
      params.require(:immunization_schedule).permit(:vaxx_name, :scheduled_date, :child_id, :medic_id)
    end
end
