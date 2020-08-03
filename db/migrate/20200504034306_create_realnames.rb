class CreateRealnames < ActiveRecord::Migration[6.0]
  def change
    create_table :realnames do |t|
      t.bigint :user_id
      t.index :user_id
      t.string :realname
      t.string :phone
      t.string :province
      t.string :city
      t.string :district
      t.string :address
      t.string :adcode
      t.integer :status
      t.string :modifymsg
      t.string :vcode
      t.datetime :vcodetime

      t.timestamps
    end
  end
end
