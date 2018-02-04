require 'spec_helper'
require 'byebug'

describe 'User', type: :model do
  let(:usuario_prueba) { create(:user) }

  it 'test 1' do
    debugger
  end
end
