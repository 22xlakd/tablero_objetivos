class CreateRegistros < ActiveRecord::Migration
  def change
    create_table :registros do |t|
      t.date :fecha
      t.integer :codigo_sucursal
      t.references :variable, index: true, foreign_key: true
      t.decimal :value, precision: 10, scale: 2

      t.timestamps null: false
    end

    add_index :registros, [:codigo_sucursal], :name => 'index_registros_on_codigo_sucursal'
  end
end
