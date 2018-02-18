class CreateVariables < ActiveRecord::Migration
  def change
    create_table :variables do |t|
      t.string :nombre
      t.string :tipo
      t.decimal :valor_objetivo, precision: 10, scale: 2
      t.decimal :proyeccion_mensual, precision: 10, scale: 2
      t.decimal :porcentaje_proyectado, precision: 10, scale: 2
      t.integer :puntaje

      t.timestamps null: false
    end
  end
end
