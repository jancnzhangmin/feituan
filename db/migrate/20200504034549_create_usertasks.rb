class CreateUsertasks < ActiveRecord::Migration[6.0]
  def change
    create_table :usertasks do |t|
      t.bigint :user_id
      t.index :user_id
      t.bigint :order_id
      t.index :order_id
      t.bigint :agent_id
      t.index :agent_id
      t.float :amount

      t.timestamps
    end
  end
end
