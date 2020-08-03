class CreateFreights < ActiveRecord::Migration[6.0]
  def change
    create_table :freights do |t|
      t.bigint :order_id
      t.index :order_id
      t.float :amount

      t.timestamps
    end
  end
end
