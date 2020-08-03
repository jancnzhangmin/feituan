class CreateCharges < ActiveRecord::Migration[6.0]
  def change
    create_table :charges do |t|
      t.bigint :user_id
      t.float :charge
      t.index :user_id

      t.timestamps
    end
  end
end
