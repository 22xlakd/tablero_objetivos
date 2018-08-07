class AddMesAnioToObjetivos < ActiveRecord::Migration
  def change
    add_column :objetivos, :mes, :integer
    add_column :objetivos, :anio, :integer

    remove_index :objetivos, name: 'index_objetivos_on_user_id_and_variable_id'
    add_index :objetivos, [:user_id, :variable_id, :mes, :anio], unique: true
  end
end
