require 'rails_helper'
require 'byebug'

describe Objetivo, type: :model do
  let!(:variable) { create(:variable, puntaje: 4) }
  let!(:user) { create(:sucursal_user) }
  let!(:objetivo) { create(:objetivo, variable: variable, proyeccion_mensual: 5, porcentaje_proyectado: 5, user: user, mes: 5, anio: 2020) }

  xcontext 'validating proyeccion_mensual' do
    it "doesn't save objetivo when proyeccion_mensual is not number" do
      objetivo.proyeccion_mensual = 'adas'

      expect(objetivo.save).to be false
      expect(objetivo.errors.count).to eq(1)
      expect(objetivo.errors.full_messages.join(',')).to eq('Proyección Mensual No es un número')
    end

    it "doesn't save objetivo with proyeccion_mensual < 0" do
      objetivo.proyeccion_mensual = -5

      expect(objetivo.save).to be false
      expect(objetivo.errors.count).to eq(1)
      expect(objetivo.errors.full_messages.join(',')).to eq('Proyección Mensual No puede ser negativo')
    end
  end

  xcontext 'validating porcentaje proyectado' do
    it "doesn't save objetivo when porcentaje proyectado is not number" do
      objetivo.porcentaje_proyectado = 'adas'

      expect(objetivo.save).to be false
      expect(objetivo.errors.count).to eq(1)
      expect(objetivo.errors.full_messages.join(',')).to eq('Porcentaje proyectado No es un número')
    end

    it "doesn't save objetivo with porcentaje_proyectado < 0" do
      objetivo.porcentaje_proyectado = -5

      expect(objetivo.save).to be false
      expect(objetivo.errors.count).to eq(1)
      expect(objetivo.errors.full_messages.join(',')).to eq('Porcentaje proyectado No puede ser negativo')
    end
  end

  context 'validating references to variable' do
    it "doesn't save model without a variable asociated" do
      objetivo.variable = nil

      expect(objetivo.save).to be false
      expect(objetivo.errors.count).to eq(1)
      expect(objetivo.errors.full_messages.join(',')).to eq('Variable No puede estar en blanco')
    end
  end

  context 'validating references to user' do
    it "doesn't save model without a user asociated" do
      objetivo.user = nil

      expect(objetivo.save).to be false
      expect(objetivo.errors.count).to eq(1)
      expect(objetivo.errors.full_messages.join(',')).to eq('Usuario No puede estar en blanco')
    end
  end

  context 'validating unique objetivo per user, variable, mes and anio' do
    it "doesn't create an objective with same user, variable, mes and anio" do
      objetivo2 = Objetivo.create(variable: variable, proyeccion_mensual: 5, porcentaje_proyectado: 5, user: user, mes: 5, anio: 2020)
      expect(objetivo2.errors.count).to eq(4)
      expect(objetivo2.errors.full_messages.join(', ')).to eq('Usuario Ya existe el objetivo para el usuario y la variable seleccionada, Variable Ya existe el objetivo para el usuario y la variable seleccionada, Mes Ya existe el objetivo para el usuario, variable, mes y año seleccionados, Año Ya existe el objetivo para el usuario, variable mes y año seleccionados')
    end
  end
end
