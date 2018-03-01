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

    trait :admin_user do
      after :create do
        FactoryBot.create(:role, name: 'admin')
      end
    end

    trait :sucursal_user do
      after :create do
        FactoryBot.create(:role, name: 'sucursal')
      end
    end
  end
end
