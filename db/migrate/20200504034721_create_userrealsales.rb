class CreateUserrealsales < ActiveRecord::Migration[6.0]
  def change
    create_table :userrealsales do |t|
      t.bigint :order_id
      t.index :order_id
      t.bigint :user_id
      t.index :user_id
      t.float :amount

      t.timestamps
    end
  end
end
