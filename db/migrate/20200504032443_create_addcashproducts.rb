class CreateAddcashproducts < ActiveRecord::Migration[6.0]
  def change
    create_table :addcashproducts do |t|
      t.bigint :addcash_id
      t.index :addcash_id
      t.bigint :product_id
      t.index :product_id
      t.float :innumber
      t.float :outnumber
      t.float :limitnumber
      t.float :buynumber

      t.timestamps
    end
  end
end
