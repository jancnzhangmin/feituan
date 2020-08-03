class CreateAddcashlocks < ActiveRecord::Migration[6.0]
  def change
    create_table :addcashlocks do |t|
      t.bigint :addcashproduct_id
      t.index :addcashproduct_id
      t.float :number
      t.string :ordernumber

      t.timestamps
    end
  end
end
