class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :openid
      t.string :unionid
      t.string :token
      t.string :nickname
      t.string :name
      t.string :aliasname
      t.string :headurl
      t.integer :realnamestatus
      t.integer :isagent

      t.timestamps
    end
  end
end
