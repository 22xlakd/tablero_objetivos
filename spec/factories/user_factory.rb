FactoryBot.define do
  sequence :user_authentication_token do |n|
    "xxxx#{Time.now.to_i}#{rand(1000)}#{n}xxxxxxxxxxxxx"
  end

  factory :user do
    email { generate(:random_email) }
    nombre { 'Juan' }
    apellido { 'Perez' }
    password 'secretrevelations'
    password_confirmation { password }
    codigo_sucursal { 1234 }

    factory :admin_user do
      spree_roles { [Role.find_by(name: 'admin') || create(:role, name: 'admin')] }
    end
  end
end
