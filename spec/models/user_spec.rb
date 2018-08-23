require 'rails_helper'
require 'byebug'

describe User, type: :model do
  include ActiveSupport::Testing::TimeHelpers

  subject { create(:sucursal_user, codigo_sucursal: 3) }
  let(:user2) { create(:sucursal_user, codigo_sucursal: 14) }
  let(:variable) { create(:variable, puntaje: 4) }
  let(:variable2) { create(:variable, puntaje: 7) }

  let(:registro1) { create(:registro, fecha: Time.zone.parse('2018-02-01'), user: subject, value: 12, variable: variable) }
  let(:registro2) { create(:registro, fecha: Time.zone.parse('2018-02-02'), user: subject, value: 14, variable: variable) }
  let(:registro3) { create(:registro, fecha: Time.zone.parse('2018-02-01'), user: user2, value: 52, variable: variable) }
  let(:registro4) { create(:registro, fecha: Time.zone.parse('2018-02-02'), user: user2, value: 59, variable: variable) }
  let(:registro5) { create(:registro, fecha: Time.zone.parse('2018-02-03'), user: user2, value: 71, variable: variable) }
  let(:registro6) { create(:registro, fecha: Time.zone.parse('2018-02-03'), user: subject, value: 28, variable: variable) }
  let(:registro7) { create(:registro, fecha: Time.zone.parse('2018-02-11'), user: subject, value: 58, variable: variable) }
  let(:registro8) { create(:registro, fecha: Time.zone.parse('2018-02-15'), user: subject, value: 176, variable: variable) }
  let(:registro9) { create(:registro, fecha: Time.zone.parse('2018-02-04'), user: user2, value: 118, variable: variable) }
  let(:registro10) { create(:registro, fecha: Time.zone.parse('2018-02-11'), user: user2, value: 158, variable: variable) }
  let(:registro11) { create(:registro, fecha: Time.zone.parse('2018-02-15'), user: user2, value: 218, variable: variable) }
  let(:registro12) { create(:registro, fecha: Time.zone.parse('2018-04-29'), user: subject, value: 218, variable: variable) }
  let(:registro13) { create(:registro, fecha: Time.zone.parse('2018-03-31'), user: user2, value: 315, variable: variable) }

  let(:objetivo) { create(:objetivo, valor: 145, user: subject, variable: variable, mes: 2, anio: 2018) }
  let(:objetivo2) { create(:objetivo, valor: 118, user: user2, variable: variable, mes: 2, anio: 2018) }

  let(:reg1) { create(:registro, fecha: Time.zone.parse('2018-02-02'), user: subject, value: 122, variable: variable2) }
  let(:reg2) { create(:registro, fecha: Time.zone.parse('2018-02-04'), user: subject, value: 221, variable: variable2) }
  let(:reg3) { create(:registro, fecha: Time.zone.parse('2018-02-01'), user: user2, value: 52, variable: variable2) }
  let(:reg4) { create(:registro, fecha: Time.zone.parse('2018-02-03'), user: user2, value: 117, variable: variable2) }
  let(:reg5) { create(:registro, fecha: Time.zone.parse('2018-02-06'), user: user2, value: 171, variable: variable2) }
  let(:reg6) { create(:registro, fecha: Time.zone.parse('2018-02-07'), user: user2, value: 195, variable: variable2) }
  let(:reg7) { create(:registro, fecha: Time.zone.parse('2018-02-17'), user: user2, value: 221, variable: variable2) }
  let(:reg8) { create(:registro, fecha: Time.zone.parse('2018-02-27'), user: user2, value: 256, variable: variable2) }
  let(:reg9) { create(:registro, fecha: Time.zone.parse('2018-02-07'), user: subject, value: 245, variable: variable2) }
  let(:reg10) { create(:registro, fecha: Time.zone.parse('2018-02-17'), user: subject, value: 272, variable: variable2) }
  let(:reg11) { create(:registro, fecha: Time.zone.parse('2018-02-27'), user: subject, value: 321, variable: variable2) }
  let(:reg12) { create(:registro, fecha: Time.zone.parse('2018-06-27'), user: subject, value: 321, variable: variable2) }
  let(:reg13) { create(:registro, fecha: Time.zone.parse('2018-11-27'), user: user2, value: 367, variable: variable2) }

  let(:objetivo3) { create(:objetivo, valor: 185, user: subject, variable: variable2, mes: 3, anio: 2018) }
  let(:objetivo4) { create(:objetivo, valor: 356, user: user2, variable: variable2, mes: 3, anio: 2018) }
  let(:objetivo5) { create(:objetivo, valor: 240, user: subject, variable: variable2, mes: 2, anio: 2018) }
  let(:objetivo6) { create(:objetivo, valor: 356, user: user2, variable: variable2, mes: 2, anio: 2018) }


  before(:each) do
    variable.objetivos = [objetivo, objetivo2]
    variable.registros = [registro1, registro2, registro3, registro4, registro5, registro6, registro7, registro8, registro9, registro10, registro11, registro12, registro13]
    variable2.objetivos = [objetivo3, objetivo4, objetivo5, objetivo6]
    variable2.registros = [reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, reg10, reg11, reg12, reg13]
  end

  it 'finds user role' do
    expect(subject.include_role?('sucursal')).to be true
    expect(subject.include_role?('admin')).to be false
  end

  context '#calculating points' do
    it 'sums month points correcly' do
      travel_to Time.new(2018, 2, 10, 1, 0, 0)
      expect(subject.calculate_current_month_points).to eq(7)
      expect(user2.calculate_current_month_points).to eq(4)

      travel_to Time.new(2018, 2, 28, 1, 0, 0)
      expect(subject.calculate_current_month_points).to eq(11)
      expect(user2.calculate_current_month_points).to eq(4)
    end

    it 'calculate year points' do
      expect(subject.calculate_year_points('2018')).to eq(11)
      expect(user2.calculate_year_points('2018')).to eq(4)
    end

    it 'calculate current value' do
      travel_to Time.new(2018, 2, 11, 1, 0, 0)
      expect(subject.calculate_current_value(variable.id)).to eq(58)

      travel_to Time.new(2018, 2, 16, 1, 0, 0)
      expect(subject.calculate_current_value(variable.id)).to eq(176)
    end
  end

  context '#best_objective' do
  end
end
