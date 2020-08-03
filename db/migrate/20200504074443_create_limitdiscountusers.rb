class CreateLimitdiscountusers < ActiveRecord::Migration[6.0]
  def change
    create_table :limitdiscountusers do |t|
      t.bigint :limitdiscount_id
      t.index :limitdiscount_id
      t.bigint :user_id

      t.timestamps
    end
  end
end
