FactoryBot.define do
  factory :variable do
    nombre { FFaker::Product.unique.brand }
    tipo 'entero'
    puntaje 1
  end
end
