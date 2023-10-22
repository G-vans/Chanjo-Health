class SmsController < ApplicationController
    def new_sms
    end

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
  
    # Convert the date_of_birth string to a Date object
    date_of_birth = child.date_of_birth
  
    # Calculate the next immunization date and days left
    next_immunization_date = nil
    days_left = nil
    immunization_name = nil
  
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
  
    if next_immunization_date && days_left && immunization_name
  
      message = "Dear #{parent}, the next immunization for Baby #{baby} is on #{next_immunization_date}. There are #{days_left} days left. Remember this will be #{immunization_name}"
      flash[:notice] = "Message sent successfully"
    else
      message = "No upcoming immunizations scheduled for Baby #{baby}"
    end
  
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
end
  