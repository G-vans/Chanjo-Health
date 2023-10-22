class FollowsController < ApplicationController
  before_action :set_follow, only: %i[ show edit update destroy ]

  # GET /follows or /follows.json
  def index
    @follows = Follow.all
  end

  # GET /follows/1 or /follows/1.json
  def show
  end

  # GET /follows/new
  def new
    @follow = Follow.new
  end

  # GET /follows/1/edit
  def edit
  end

  # POST /follows or /follows.json
  def create
    @follow = Follow.new(follow_params)

    respond_to do |format|
      if @follow.save
        format.html { redirect_to follow_url(@follow), notice: "Follow was successfully created." }
        format.json { render :show, status: :created, location: @follow }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @follow.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /follows/1 or /follows/1.json
  def update
    respond_to do |format|
      if @follow.update(follow_params)
        format.html { redirect_to follow_url(@follow), notice: "Follow was successfully updated." }
        format.json { render :show, status: :ok, location: @follow }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @follow.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /follows/1 or /follows/1.json
  def destroy
    @follow.destroy

    respond_to do |format|
      format.html { redirect_to follows_url, notice: "Follow was successfully destroyed." }
      format.json { head :no_content }
    end
  end

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
    xml.Say "Hello! This is a follow up message on your baby's missed immunization. Please go to the nearest branch of Nairobi Hospital for your baby's missed jab"
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


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_follow
      @follow = Follow.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def follow_params
      params.require(:follow).permit(:name, :phone_number)
    end
end
