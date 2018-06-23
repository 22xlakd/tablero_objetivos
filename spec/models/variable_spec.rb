require 'rails_helper'
require 'byebug'

describe Variable, type: :model do
  let(:user) { create(:sucursal_user) }
  let(:user2) { create(:sucursal_user) }
  let(:user3) { create(:sucursal_user) }
  let(:user4) { create(:sucursal_user) }
  let(:user5) { create(:sucursal_user) }
  let(:objetivo) { create(:objetivo, valor: 45, user: user) }
  let(:objetivo3) { create(:objetivo, valor: 11, user: user3) }
  let(:objetivo4) { create(:objetivo, valor: 67, user: user4) }
  let(:objetivo5) { create(:objetivo, valor: 87, user: user5) }

  let(:variable) { create(:variable, nombre: 'Ventas totales', puntaje: 4, objetivos: [objetivo, objetivo5, objetivo3, objetivo4]) }
  let(:registro1) { create(:registro, fecha: Time.zone.today.beginning_of_month, user: user, variable: variable, value: 145) }
  let(:registro2) { create(:registro, fecha: Time.zone.today.beginning_of_month, user: user3, variable: variable, value: 521) }
  let(:registro3) { create(:registro, fecha: Time.zone.today.beginning_of_month, user: user4, variable: variable, value: 109) }
  let(:registro4) { create(:registro, fecha: Time.zone.today.beginning_of_month + 1, user: user, variable: variable, value: 124) }
  let(:registro5) { create(:registro, fecha: Time.zone.today.beginning_of_month + 1, user: user3, variable: variable, value: 491) }
  let(:registro6) { create(:registro, fecha: Time.zone.today.beginning_of_month + 3, user: user4, variable: variable, value: 307) }
  let(:registro7) { create(:registro, fecha: Time.zone.today.beginning_of_month + 8, user: user3, variable: variable, value: 361) }

  before do
    variable.registros << registro1
    variable.registros << registro2
    variable.registros << registro3
    variable.registros << registro4
    variable.registros << registro5
    variable.registros << registro6
    variable.registros << registro7
  end

  context '#objetivo_by_user' do
    it 'returns objetivo for user' do
      expect(variable.objetivo_by_user(user)).not_to be nil
      expect(variable.objetivo_by_user(user).valor).to eq(45)
    end

    it "returns nil if objetivo doesn't exist for user" do
      expect(variable.objetivo_by_user(user2)).to be nil
    end
  end

  context 'validating tipo' do
    it 'save model when tipo has correct value' do
      variable.tipo = 'moneda'

      expect(variable.save).to be true
    end

    it "doesn't save model if tipo has incorrect value" do
      variable.tipo = 'objetivo'

      expect(variable.save).to be false
      expect(variable.errors.count).to eq(1)
      expect(variable.errors.full_messages.join(',')).to eq('Tipo de variable El tipo de variable ingresado no pertence a los valores aceptados ["porcentaje", "entero", "moneda"]')
    end
  end

  context 'validating nombre' do
    it 'save model with name' do
      variable2 = Variable.new(nombre: 'Facturacion', tipo: 'moneda', puntaje: 1)

      expect(variable2.save).to be true
    end

    it "doesn't save variable without name" do
      variable2 = Variable.new(tipo: 'moneda', puntaje: 1)

      expect(variable2.save).to be false
      expect(variable2.errors.count).to eq(1)
      expect(variable2.errors.full_messages.join(',')).to eq('Nombre No puede estar en blanco')
    end
  end

  context 'validating puntaje' do
    it 'save model with puntaje > 0' do
      variable2 = Variable.new(nombre: 'Facturacion', tipo: 'moneda', puntaje: 3)

      expect(variable2.save).to be true
    end

    it "doesn't save variable when puntaje is not number" do
      variable2 = Variable.new(nombre: 'Tarjetas', tipo: 'entero', puntaje: 'sdas')

      expect(variable2.save).to be false
      expect(variable2.errors.count).to eq(1)
      expect(variable2.errors.full_messages.join(',')).to eq('Puntaje No es un número')
    end

    it "doesn't save variable with puntaje < 0" do
      variable2 = Variable.new(nombre: 'Tarjetas', tipo: 'entero', puntaje: -6)

      expect(variable2.save).to be false
      expect(variable2.errors.count).to eq(1)
      expect(variable2.errors.full_messages.join(',')).to eq('Puntaje No puede ser negativo')
    end
  end

  it 'returns variable types' do
    expect(variable.variable_types).to eq(['porcentaje', 'entero', 'moneda'])
  end

  context '#admin dashboard' do
    it 'returns a hash with the dataset of the total goal' do
      hsh = variable.total_goal
      expect(hsh.class).to eq(Hash)
      expect(hsh[:label]).to eq('Objetivo Ventas totales')
      expect(hsh[:fill]).to be false
      expect(hsh[:data].class).to eq(Array)
      expect(hsh[:data].count).to eq(Time.days_in_month(Time.zone.today.month, Time.zone.today.year))
      expect(hsh[:data].first).to eq(hsh[:data].last)
      expect(hsh[:data].first).to eq(210)
    end

    it 'returns a hash with the dataset of the total of the current value' do
      hsh = variable.current_total_value
      expect(hsh.class).to eq(Hash)
      expect(hsh[:label]).to eq('Valor Actual Total')
      expect(hsh[:fill]).to be false
      expect(hsh[:data].class).to eq(Array)
      expect(hsh[:data].count).to eq(Time.days_in_month(Time.zone.today.month, Time.zone.today.year))
      expect(hsh[:data].first).to eq(775)
      expect(hsh[:data][1]).to eq(1390)
      expect(hsh[:data][2]).to eq(1390)
      expect(hsh[:data][3]).to eq(1697)
      expect(hsh[:data][6]).to eq(1697)
      expect(hsh[:data][9]).to eq(2058)
    end

    it 'returns a hash with the dataset of the total prediction', focus: true do
      hsh = variable.total_prediction
      expect(hsh.class).to eq(Hash)
      expect(hsh[:label]).to eq('Proyección Ventas totales')
      expect(hsh[:fill]).to be false
      expect(hsh[:data].class).to eq(Array)
      expect(hsh[:data].first).to eq(23_250.0)
      expect(hsh[:data][1]).to eq(20_850.0)
      expect(hsh[:data][2]).to eq(13_900.0)
      expect(hsh[:data][3]).to eq(12_727.5)
      expect(hsh[:data][4]).to eq(10_182.0)
      expect(hsh[:data][6]).to eq(7272.86)
      expect(hsh[:data][8]).to eq(6860.0)
      expect(hsh[:data][9]).to eq(6174.0)
    end

    it 'returns a hash with the dataset of the total prediction percent' do
      variable.total_prediction
      hsh = variable.total_prediction_percent
      expect(hsh.class).to eq(Hash)
      expect(hsh[:label]).to eq('Porcentaje proyectado Ventas totales')
      expect(hsh[:fill]).to be false
      expect(hsh[:data].class).to eq(Array)
      expect(hsh[:data].first).to eq(171.34)
      expect(hsh[:data][1]).to eq(171.34)
      expect(hsh[:data][2]).to eq(171.34)
      expect(hsh[:data][3]).to eq(171.34)
      expect(hsh[:data][6]).to eq(171.34)
      expect(hsh[:data][9]).to eq(171.34)
    end
  end
end
