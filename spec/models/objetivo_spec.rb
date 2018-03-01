require 'rails_helper'
require 'byebug'

describe Objetivo, type: :model do
  let(:variable) { create(:variable, puntaje: 4) }
  let(:user) { create(:sucursal_user) }

  context 'validating proyeccion_mensual' do
    it 'save model with proyeccion_mensual > 0' do
      objetivo = Objetivo.new(variable: variable, proyeccion_mensual: 5)

      expect(objetivo.save).to be true
    end

    it "doesn't save objetivo when proyeccion_mensual is not number" do
      objetivo = Objetivo.new(variable: variable, proyeccion_mensual: 'adas')

      expect(objetivo.save).to be false
      expect(objetivo.errors.count).to eq(1)
      expect(objetivo.errors.full_messages.join(',')).to eq('Proyección Mensual No es un número')
    end

    it "doesn't save variable with proyeccion_mensual < 0" do
      objetivo = Objetivo.new(variable: variable, proyeccion_mensual: -5)

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
  end
end
