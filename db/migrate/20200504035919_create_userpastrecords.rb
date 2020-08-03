class CreateUserpastrecords < ActiveRecord::Migration[6.0]
  def change
    create_table :userpastrecords do |t|
      t.bigint :user_id
      t.index :user_id
      t.bigint :examine_id
      t.index :examine_id
      t.bigint :last_id
      t.bigint :current_id

      t.timestamps
    end
  end
end
