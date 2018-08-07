FactoryBot.define do
  factory :objetivo do
    proyeccion_mensual { FFaker.numerify('##.##') }
    porcentaje_proyectado { FFaker.numerify('##.##') }
    mes { FFaker::Time.date(year_range: 5, year_latest: 1990).split('-')[1].to_i }
    anio { FFaker::Time.date(year_range: 5, year_latest: 1990).split('-')[0].to_i }
    valor { FFaker.numerify('##.##') }
    user { FactoryBot.create(:sucursal_user) }
    variable { FactoryBot.create(:variable) }
  end
end
