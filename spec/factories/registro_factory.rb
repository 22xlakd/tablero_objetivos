FactoryBot.define do
  factory :registro do
    fecha { Time.zone.today }
    user { FactoryBot.create(:sucursal_user) }
    variable { FactoryBot.create(:variable) }
    value { FFaker.numerify('###') }
  end
end
