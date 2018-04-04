require 'rails_helper'
require 'byebug'
require 'cancan/matchers'

describe Ability, type: :model do
  let(:sucursal) { create(:role, name: 'Sucursal') }
  let(:admin) { create(:role, name: 'admin') }
  let(:usuario) { create(:user, roles: [sucursal]) }
  let(:usuario2) { create(:user, roles: [admin]) }
  let(:usuario3) { create(:user, nombre: 'Usuario 2', roles: [sucursal]) }
  let(:variable) { create(:variable) }
  let(:r_1) { create(:registro, variable: variable, user: usuario) }
  let(:registro2) { create(:registro, variable: variable, user: usuario3) }
  let(:objetivo1) { create(:objetivo, variable: variable, user: usuario) }
  let(:objetivo2) { create(:objetivo, variable: variable, user: usuario3) }
  let(:ability) { Ability.new(usuario) }

  before do
    variable.objetivos << objetivo1
    variable.objetivos << objetivo2
  end

  it 'cannot delete admin role' do
    expect(ability).not_to be_able_to(:destroy, admin)

    ability_2 = Ability.new(usuario2)
    expect(ability_2).not_to be_able_to(:destroy, admin)
  end

  context 'when user has role sucursal' do
    it 'cannot save another user data' do
      expect(ability).not_to be_able_to(:save, usuario2)
    end

    it 'cannot create another user' do
      expect(ability).not_to be_able_to(:create, User)
    end

    it 'can read another user data' do
      expect(ability).to be_able_to(:read, usuario2)
    end

    it 'cannot edit variable' do
      expect(ability).not_to be_able_to(:update, variable)
    end

    it 'cannot delete variable' do
      expect(ability).not_to be_able_to(:destroy, variable)
    end

    it 'can read records that belongs to him' do
      expect(ability).to be_able_to(:read, r_1)
    end

    it 'cannot read records that belongs to another user' do
      expect(ability).not_to be_able_to(:read, registro2)
    end

    it 'can read objectives that belongs to him' do
      expect(ability).to be_able_to(:read, objetivo1)
    end

    it 'cannot read objectives that belongs to another user' do
      expect(ability).not_to be_able_to(:read, objetivo2)
    end

    it 'cannot edit registro' do
      expect(ability).not_to be_able_to(:update, r_1)
      expect(ability).not_to be_able_to(:update, registro2)
    end

    it 'cannot edit objetivo' do
      expect(ability).not_to be_able_to(:update, objetivo1)
      expect(ability).not_to be_able_to(:update, objetivo2)
    end

    it 'cannot delete registro' do
      expect(ability).not_to be_able_to(:destroy, r_1)
      expect(ability).not_to be_able_to(:destroy, registro2)
    end

    it 'cannot delete objetivo' do
      expect(ability).not_to be_able_to(:destroy, objetivo1)
      expect(ability).not_to be_able_to(:destroy, objetivo2)
    end
  end

  context 'when user has admin role' do
    let(:ability_admin) { Ability.new(usuario2) }

    it 'can manage another user' do
      expect(ability_admin).to be_able_to(:manage, User.new)
    end
  end
end
