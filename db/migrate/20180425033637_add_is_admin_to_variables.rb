class AddIsAdminToVariables < ActiveRecord::Migration
  def change
    add_column :variables, :is_admin, :boolean
  end
end
