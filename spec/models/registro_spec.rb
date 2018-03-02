require 'rails_helper'
require 'byebug'

describe Registro, type: :model do
  let(:variable) { create(:variable, puntaje: 14) }
  let(:user) { create(:sucursal_user) }
  let(:registro) { create(:registro, fecha: Time.zone.today, user: user, variable: variable, value: 12) }

  it "doesn't save registro if fecha is nil" do
    registro.fecha = nil

    expect(registro.save).to be false
    expect(registro.errors.count).to eq(1)
    expect(registro.errors.full_messages.join(',')).to eq('Fecha No puede estar en blanco')
  end

  it "doesn't save registro if user is nil" do
    registro.user = nil

    expect(registro.save).to be false
    expect(registro.errors.count).to eq(1)
    expect(registro.errors.full_messages.join(',')).to eq('Usuario No puede estar en blanco')
  end

  it "doesn't save registro if variable is nil" do
    registro.variable = nil

    expect(registro.save).to be false
    expect(registro.errors.count).to eq(1)
    expect(registro.errors.full_messages.join(',')).to eq('Variable No puede estar en blanco')
  end

  it "doesn't save registro if value is nil" do
    registro.value = nil

    expect(registro.save).to be false
    expect(registro.errors.count).to eq(1)
    expect(registro.errors.full_messages.join(',')).to eq('Valor No puede estar en blanco')
  end
end
