require 'rails_helper'
require 'byebug'

describe User, type: :model do
  subject { create(:sucursal_user, codigo_sucursal: 3) }
  let(:user2) { create(:sucursal_user, codigo_sucursal: 14) }
  let(:variable) { create(:variable, puntaje: 4) }
  let(:variable2) { create(:variable, puntaje: 7) }

  let(:registro1) { create(:registro, user: subject, value: 12, variable: variable) }
  let(:registro2) { create(:registro, user: subject, value: 2, variable: variable) }
  let(:objetivo) { create(:objetivo, valor: 45, user: subject, variable: variable) }
  let(:objetivo2) { create(:objetivo, valor: 34, user: user2, variable: variable) }
  let(:registro3) { create(:registro, user: user2, value: 52, variable: variable) }
  let(:registro4) { create(:registro, user: user2, value: 7, variable: variable) }
  let(:registro5) { create(:registro, user: user2, value: 71, variable: variable) }
  let(:reg1) { create(:registro, user: subject, value: 122, variable: variable2) }
  let(:reg2) { create(:registro, user: subject, value: 221, variable: variable2) }
  let(:objetivo3) { create(:objetivo, valor: 85, user: subject, variable: variable2) }
  let(:objetivo4) { create(:objetivo, valor: 156, user: user2, variable: variable2) }
  let(:reg3) { create(:registro, user: user2, value: 52, variable: variable2) }
  let(:reg4) { create(:registro, user: user2, value: 7, variable: variable2) }
  let(:reg5) { create(:registro, user: user2, value: 71, variable: variable2) }

  before(:each) do
    variable.objetivos = [objetivo, objetivo2]
    variable.registros = [registro1, registro2, registro3, registro4, registro5]
    variable2.objetivos = [objetivo3, objetivo4]
    variable2.registros = [reg1, reg2, reg3, reg4, reg5]
  end

  context '#calculating points' do
    it 'sums points correcly' do
      debugger
      expect(subject.calculate_current_month_points).to eq(7)
      expect(user2.calculate_current_month_points).to eq(11)
    end
  end
end
