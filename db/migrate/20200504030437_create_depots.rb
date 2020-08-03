class CreateDepots < ActiveRecord::Migration[6.0]
  def change
    create_table :depots do |t|
      t.bigint :product_id
      t.index :product_id
      t.bigint :buyparamoption_id
      t.index :buyparamoption_id
      t.float :number
      t.float :cost

      t.timestamps
    end
  end
end
