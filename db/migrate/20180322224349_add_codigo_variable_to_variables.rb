class AddCodigoVariableToVariables < ActiveRecord::Migration
  def change
    add_column :variables, :codigo_variable, :integer
    add_index :variables, :codigo_variable
  end
end
