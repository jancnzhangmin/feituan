class AddUpidToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :up_id, :bigint
    add_index :users, [:up_id, :token]
  end
end
