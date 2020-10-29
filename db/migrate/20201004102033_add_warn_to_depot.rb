class AddWarnToDepot < ActiveRecord::Migration[6.0]
  def change
    add_column :depots, :warn, :float
  end
end
