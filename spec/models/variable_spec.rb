require 'rails_helper'
require 'byebug'

describe Variable, type: :model do
  let(:user) { create(:sucursal_user) }
  let(:user2) { create(:sucursal_user) }
  let(:objetivo) { create(:objetivo, valor: 45, user: user) }
  let(:variable) { create(:variable, puntaje: 4, objetivos: [objetivo]) }

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
end
