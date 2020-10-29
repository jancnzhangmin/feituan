class AddKeywordToDelivermode < ActiveRecord::Migration[6.0]
  def change
    add_column :delivermodes, :keyword, :string
  end
end
