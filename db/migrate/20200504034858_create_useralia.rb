class CreateUseralia < ActiveRecord::Migration[6.0]
  def change
    create_table :useralia do |t|
      t.bigint :user_id
      t.index :user_id
      t.bigint :aliauser_id
      t.index :aliauser_id
      t.string :aliasname

      t.timestamps
    end
  end
end
