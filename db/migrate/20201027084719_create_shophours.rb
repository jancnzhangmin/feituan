class CreateShophours < ActiveRecord::Migration[6.0]
  def change
    create_table :shophours do |t|
      t.bigint :seller_id
      t.time :begintime
      t.time :endtime
      t.index :seller_id

      t.timestamps
    end
  end
end
