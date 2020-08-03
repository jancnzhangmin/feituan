class AddTotalToDepot < ActiveRecord::Migration[6.0]
  def change
    add_column :depots, :total, :float
  end
end
