class CreateOrderprintdetails < ActiveRecord::Migration[6.0]
  def change
    create_table :orderprintdetails do |t|
      t.bigint :orderprint_id
      t.bigint :orderproduct_id
      t.float :number
      t.index :orderprint_id
      t.index :orderproduct_id

      t.timestamps
    end
  end
end
