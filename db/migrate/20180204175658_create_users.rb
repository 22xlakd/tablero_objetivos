class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :nombre
      t.string :apellido
      t.string :password_digest
      t.string :codigo_sucursal

      t.timestamps null: false
    end
  end
end
