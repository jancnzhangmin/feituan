class CreateAddcashgives < ActiveRecord::Migration[6.0]
  def change
    create_table :addcashgives do |t|
      t.bigint :addcash_id
      t.index :addcash_id
      t.bigint :product_id
      t.index :product_id
      t.float :price

      t.timestamps
    end
  end
end
