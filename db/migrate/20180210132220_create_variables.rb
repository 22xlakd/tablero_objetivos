class CreateVariables < ActiveRecord::Migration
  def change
    create_table :variables do |t|
      t.string :nombre
      t.string :tipo
      t.decimal :proyeccion_mensual
      t.decimal :porcentaje_proyectado
      t.integer :puntaje

      t.timestamps null: false
    end
  end
end
