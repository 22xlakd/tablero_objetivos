json.extract! user, :id, :nombre, :apellido, :email, :codigo_sucursal, :created_at, :updated_at
json.url user_url(user, format: :json)
