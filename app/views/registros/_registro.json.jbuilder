json.extract! registro, :id, :fecha, :sucursal_id, :variable_id, :value, :created_at, :updated_at
json.url registro_url(registro, format: :json)
