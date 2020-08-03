class CreateBuyfullgiveproducts < ActiveRecord::Migration[6.0]
  def change
    create_table :buyfullgiveproducts do |t|
      t.bigint :buyfull_id
      t.bigint :product_id
      t.float :givenumber
      t.float :innumber
      t.float :outnumber

      t.timestamps
    end
    add_index :buyfullgiveproducts , [:buyfull_id, :product_id]
  end
end
