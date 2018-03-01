require 'rails_helper'
require 'byebug'

describe Objetivo, type: :model do
  let(:variable) { create(:variable, puntaje: 4) }
  let(:user) { create(:sucursal_user) }

  context 'validating proyeccion_mensual' do
    it 'save model with proyeccion_mensual > 0' do
      objetivo = Objetivo.new(variable: variable, proyeccion_mensual: 5, user: user)

      expect(objetivo.save).to be true
    end

    it "doesn't save objetivo when proyeccion_mensual is not number" do
      objetivo = Objetivo.new(variable: variable, proyeccion_mensual: 'adas', user: user)

      expect(objetivo.save).to be false
      expect(objetivo.errors.count).to eq(1)
      expect(objetivo.errors.full_messages.join(',')).to eq('Proyección Mensual No es un número')
    end

    it "doesn't save variable with proyeccion_mensual < 0" do
      objetivo = Objetivo.new(variable: variable, proyeccion_mensual: -5, user: user)

      expect(objetivo.save).to be false
      expect(objetivo.errors.count).to eq(1)
      expect(objetivo.errors.full_messages.join(',')).to eq('Proyección Mensual No puede ser negativo')
    end
  end

  context 'validating references to variable' do
    it 'save model with a variable asociated' do
      objetivo = Objetivo.new(variable: variable, proyeccion_mensual: 5, porcentaje_proyectado: 10, user: user)

      expect(objetivo.save).to be true
    end

    it "doesn't save model without a variable asociated" do
      objetivo = Objetivo.new(proyeccion_mensual: 5, porcentaje_proyectado: 10, user: user)

      expect(objetivo.save).to be false
      expect(objetivo.errors.count).to eq(1)
      expect(objetivo.errors.full_messages.join(',')).to eq('Variable No puede estar en blanco')
    end
  end

  context 'validating references to user' do
    it 'save model with a user asociated' do
      objetivo = Objetivo.new(variable: variable, proyeccion_mensual: 5, porcentaje_proyectado: 10, user: user)

      expect(objetivo.save).to be true
    end

    it "doesn't save model without a user asociated" do
      objetivo = Objetivo.new(variable: variable, proyeccion_mensual: 5, porcentaje_proyectado: 10)

      expect(objetivo.save).to be false
      expect(objetivo.errors.count).to eq(1)
      expect(objetivo.errors.full_messages.join(',')).to eq('Usuario No puede estar en blanco')
    end
  end
end
