FactoryBot.define do
  factory :objetivo do
    proyeccion_mensual { FFaker.numerify('##.##') }
    porcentaje_proyectado { FFaker.numerify('##.##') }
    valor { FFaker.numerify('##.##') }
    user { FactoryBot.create(:sucursal_user) }
    variable { FactoryBot.create(:variable) }
  end
end
