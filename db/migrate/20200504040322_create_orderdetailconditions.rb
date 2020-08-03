class CreateOrderdetailconditions < ActiveRecord::Migration[6.0]
  def change
    create_table :orderdetailconditions do |t|
      t.bigint :orderdetail_id
      t.index :orderdetail_id
      t.bigint :buyparam_id
      t.string :buyparam
      t.bigint :buyoption_id
      t.string :buyoption

      t.timestamps
    end
  end
end
