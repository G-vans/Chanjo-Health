json.extract! immunization, :id, :vax_name, :date, :child_id, :medic_id, :created_at, :updated_at
json.url immunization_url(immunization, format: :json)
