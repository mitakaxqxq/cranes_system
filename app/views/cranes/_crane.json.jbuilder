json.extract! crane, :id, :status, :registration_date, :serial_number, :created_at, :updated_at, :type
json.url crane_url(crane, format: :json)
