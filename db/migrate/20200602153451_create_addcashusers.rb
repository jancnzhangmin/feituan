class CreateAddcashusers < ActiveRecord::Migration[6.0]
  def change
    create_table :addcashusers do |t|
      t.bigint :addcash_id
      t.bigint :user_id
      t.index :addcash_id
      t.index :user_id

      t.timestamps
    end
  end
end
