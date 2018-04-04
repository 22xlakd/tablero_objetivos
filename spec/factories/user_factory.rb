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
    codigo_sucursal { rand(1000) }

    factory :admin_user do
      roles { [Role.find_by(name: 'admin') || FactoryBot.create(:role, name: 'admin')] }
    end

    factory :sucursal_user do
      roles { [Role.find_by(name: 'sucursal') || FactoryBot.create(:role, name: 'sucursal')] }
    end
  end
end
