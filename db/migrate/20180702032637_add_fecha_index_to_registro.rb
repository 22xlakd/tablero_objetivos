class AddFechaIndexToRegistro < ActiveRecord::Migration
  def change
    add_index :registros, :fecha
  end
end
