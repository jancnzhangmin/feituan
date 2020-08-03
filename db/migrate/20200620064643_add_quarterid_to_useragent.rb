class AddQuarteridToUseragent < ActiveRecord::Migration[6.0]
  def change
    add_column :useragents, :quarter_id, :bigint
    add_index :useragents, :quarter_id
  end
end
