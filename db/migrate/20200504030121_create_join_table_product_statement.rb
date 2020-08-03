class CreateJoinTableProductStatement < ActiveRecord::Migration[6.0]
  def change
    create_join_table :products, :statements do |t|
      # t.index [:product_id, :statement_id]
      # t.index [:statement_id, :product_id]
    end
  end
end
