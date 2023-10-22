json.extract! immunization_schedule, :id, :vaxx_name, :scheduled_date, :child_id, :medic_id, :created_at, :updated_at
json.url immunization_schedule_url(immunization_schedule, format: :json)
