class CreateLimitdiscountlocks < ActiveRecord::Migration[6.0]
  def change
    create_table :limitdiscountlocks do |t|
      t.bigint :limitdiscountproduct_id
      t.index :limitdiscountproduct_id
      t.float :number
      t.string :ordernumber

      t.timestamps
    end
  end
end
