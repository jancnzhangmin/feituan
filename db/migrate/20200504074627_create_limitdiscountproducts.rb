class CreateLimitdiscountproducts < ActiveRecord::Migration[6.0]
  def change
    create_table :limitdiscountproducts do |t|
      t.bigint :limitdiscount_id
      t.index :limitdiscount_id
      t.bigint :product_id
      t.index :product_id
      t.float :rate
      t.float :innumber
      t.float :outnumber
      t.float :limitnumber

      t.timestamps
    end
  end
end
