class AddCostToIndepot < ActiveRecord::Migration[6.0]
  def change
    add_column :indepots, :cost, :float
  end
end
