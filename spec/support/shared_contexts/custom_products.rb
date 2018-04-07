shared_context 'custom products' do
  before(:each) do
    usr = FactoryBot.create(:sucursal_user, email: 'mail@temp.com', password: '12345678910', password_confirmation: '12345678910')
    v1 = FactoryBot.create(:variable, nombre: 'Cantidad de ventas', tipo: 'entero', puntaje: 5)
    v2 = FactoryBot.create(:variable, nombre: 'Monto de ventas', tipo: 'moneda', puntaje: 15)
    v3 = FactoryBot.create(:variable, nombre: 'Cobranza pampeana', tipo: 'moneda', puntaje: 7)
    v4 = FactoryBot.create(:variable, nombre: 'Consumo', tipo: 'moneda', puntaje: 17)
    FactoryBot.create(:objetivo, variable: v1, user: usr, valor: 457)
    FactoryBot.create(:objetivo, variable: v2, user: usr, valor: 135_457)
    FactoryBot.create(:objetivo, variable: v3, user: usr, valor: 14_670)
    FactoryBot.create(:objetivo, variable: v4, user: usr, valor: 1_214_670)

    FactoryBot.create(:registro, variable: v1, codigo_sucursal: usr.codigo_sucursal, fecha: Time.zone.today - 3, value: 12)
    FactoryBot.create(:registro, variable: v1, codigo_sucursal: usr.codigo_sucursal, fecha: Time.zone.today - 2, value: 42)
    FactoryBot.create(:registro, variable: v1, codigo_sucursal: usr.codigo_sucursal, fecha: Time.zone.today - 1, value: 38)
    FactoryBot.create(:registro, variable: v1, codigo_sucursal: usr.codigo_sucursal, fecha: Time.zone.today, value: 63)

    FactoryBot.create(:registro, variable: v2, codigo_sucursal: usr.codigo_sucursal, fecha: Time.zone.today - 3, value: 12_455)
    FactoryBot.create(:registro, variable: v2, codigo_sucursal: usr.codigo_sucursal, fecha: Time.zone.today - 2, value: 42_367)
    FactoryBot.create(:registro, variable: v2, codigo_sucursal: usr.codigo_sucursal, fecha: Time.zone.today - 1, value: 3_876)
    FactoryBot.create(:registro, variable: v2, codigo_sucursal: usr.codigo_sucursal, fecha: Time.zone.today, value: 634)

    FactoryBot.create(:registro, variable: v3, codigo_sucursal: usr.codigo_sucursal, fecha: Time.zone.today - 3, value: 2_155)
    FactoryBot.create(:registro, variable: v3, codigo_sucursal: usr.codigo_sucursal, fecha: Time.zone.today - 2, value: 4_668)
    FactoryBot.create(:registro, variable: v3, codigo_sucursal: usr.codigo_sucursal, fecha: Time.zone.today - 1, value: 876)
    FactoryBot.create(:registro, variable: v3, codigo_sucursal: usr.codigo_sucursal, fecha: Time.zone.today, value: 11_634)

    FactoryBot.create(:registro, variable: v4, codigo_sucursal: usr.codigo_sucursal, fecha: Time.zone.today - 3, value: 2_342_155)
    FactoryBot.create(:registro, variable: v4, codigo_sucursal: usr.codigo_sucursal, fecha: Time.zone.today - 2, value: 56_668)
    FactoryBot.create(:registro, variable: v4, codigo_sucursal: usr.codigo_sucursal, fecha: Time.zone.today - 1, value: 23_876)
    FactoryBot.create(:registro, variable: v4, codigo_sucursal: usr.codigo_sucursal, fecha: Time.zone.today, value: 61_634)
  end
end
