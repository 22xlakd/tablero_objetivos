require 'rails_helper'
require 'byebug'

describe 'TableroObjetivos', type: :feature, inaccessible: true, js: true do
  include_context 'custom products'

  before(:each) do
    page.driver.browser.manage.window.resize_to(1024, 768)

    login_as(User.first, scope: :user)
    visit authenticated_root_path
  end

  it 'display graphs with measures' do
    expect(page).to have_content('Tablero de Objetivos del mes de Abril')
    expect(page).to have_selector('div.panel-body.easypiechart-panel', count: 4)
  end
end
