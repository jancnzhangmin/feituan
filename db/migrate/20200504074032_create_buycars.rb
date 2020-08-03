class CreateBuycars < ActiveRecord::Migration[6.0]
  def change
    create_table :buycars do |t|
      t.bigint :user_id
      t.index :user_id
      t.float :number
      t.float :amount
      t.integer :producttype

      t.timestamps
    end
  end
end
