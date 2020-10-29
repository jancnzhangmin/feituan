class AddLngToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :lng, :decimal, precision:15, scale: 12
    add_column :users, :lat, :decimal, precision:15, scale: 12
  end
end
