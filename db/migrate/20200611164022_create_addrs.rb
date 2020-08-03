class CreateAddrs < ActiveRecord::Migration[6.0]
  def change
    create_table :addrs do |t|
      t.bigint :user_id
      t.string :contact
      t.string :phone
      t.string :province
      t.string :city
      t.string :district
      t.string :address
      t.string :adcode
      t.index :user_id

      t.timestamps
    end
  end
end
