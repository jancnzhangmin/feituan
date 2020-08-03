class CreateOutdepotdetails < ActiveRecord::Migration[6.0]
  def change
    create_table :outdepotdetails do |t|
      t.bigint :outdepot_id
      t.index :outdepot_id
      t.bigint :product_id
      t.index :product_id
      t.bigint :buyparamoption_id
      t.index :buyparamoption_id
      t.float :number
      t.float :price

      t.timestamps
    end
  end
end
