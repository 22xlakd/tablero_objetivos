class AddFieldsPointToUser < ActiveRecord::Migration
  def change
    add_column :users, :year_points, :integer, default: 0
    add_column :users, :current_month_points, :integer, default: 0
    add_index :users, :year_points
    add_index :users, :current_month_points
  end
end
