require 'rails_helper'
require 'byebug'
require 'cancan/matchers'

describe Ability, type: :model do
  let(:sucursal) { create(:role, name: 'Sucursal') }
  let(:admin) { create(:role, name: 'admin') }
  let(:usuario) { create(:user, roles: [sucursal]) }
  let(:usuario2) { create(:user, roles: [admin]) }
  let(:variable) { create(:variable) }
  let(:ability) { Ability.new(usuario) }

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
  end

  context 'when user has admin role' do
    let(:ability_admin) { Ability.new(usuario2) }

    it 'can manage another user' do
      expect(ability_admin).to be_able_to(:manage, User.new)
    end
  end
end
