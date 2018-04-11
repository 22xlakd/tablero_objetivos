class AddInverseToVariables < ActiveRecord::Migration
  def change
    add_column :variables, :inverse, :boolean
  end
end
