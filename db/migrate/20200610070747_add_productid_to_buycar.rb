class AddProductidToBuycar < ActiveRecord::Migration[6.0]
  def change
    add_column :buycars, :product_id, :bigint
  end
end
