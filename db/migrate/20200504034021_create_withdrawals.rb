class CreateWithdrawals < ActiveRecord::Migration[6.0]
  def change
    create_table :withdrawals do |t|
      t.bigint :user_id
      t.index :user_id
      t.float :amount

      t.timestamps
    end
  end
end
