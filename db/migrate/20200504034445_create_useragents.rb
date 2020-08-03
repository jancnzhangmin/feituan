class CreateUseragents < ActiveRecord::Migration[6.0]
  def change
    create_table :useragents do |t|
      t.bigint :agent_id
      t.index :agent_id
      t.bigint :user_id
      t.index :user_id
      t.string :name
      t.integer :examine

      t.timestamps
    end
  end
end
