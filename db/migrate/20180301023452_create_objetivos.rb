class CreateObjetivos < ActiveRecord::Migration
  def change
    create_table :objetivos do |t|
      t.decimal :proyeccion_mensual, precision: 10, scale: 2
      t.decimal :porcentaje_proyectado, precision: 10, scale: 2
      t.decimal :valor, precision: 10, scale: 2
      t.references :variable, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
