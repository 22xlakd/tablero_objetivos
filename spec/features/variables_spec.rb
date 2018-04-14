require 'rails_helper'
require 'byebug'

describe 'Variables', type: :feature, inaccessible: true, js: true do
  include_context 'custom products'

  let(:admin) { create(:admin_user) }

  before(:each) do
    page.driver.browser.manage.window.resize_to(1024, 768)

    login_as(admin, scope: :user)
    visit authenticated_root_path
  end

  context '#update_variable' do
    it 'adds sucursal objective to variable' do
      var = Variable.first
      click_link 'Variables'
      expect(page).to have_content(I18n.t(:title_variable_index))

      find(:xpath, "//a[@href='/variables/#{var.id}/edit']").click
      expect(page).to have_content(I18n.t(:update_variable, variable: var.nombre))
      click_button 'btn_add_objective'
      expect(page).to have_css('#addObjectiveToUser', visible: true)

      find('#btn_modal_add_objective').click
      expect(page).to have_link(@usr2.nombre.capitalize)
      expect(page).to have_content('Valor')
    end
  end
end
