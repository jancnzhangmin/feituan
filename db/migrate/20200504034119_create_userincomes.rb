class CreateUserincomes < ActiveRecord::Migration[6.0]
  def change
    create_table :userincomes do |t|
      t.bigint :order_id
      t.index :order_id
      t.bigint :user_id
      t.index :user_id
      t.float :amount
      t.integer :status

      t.timestamps
    end
  end
end
