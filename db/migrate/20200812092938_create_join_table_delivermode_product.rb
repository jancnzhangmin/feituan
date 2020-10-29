class CreateJoinTableDelivermodeProduct < ActiveRecord::Migration[6.0]
  def change
    create_join_table :delivermodes, :products do |t|
       t.index [:delivermode_id, :product_id]
       t.index [:product_id, :delivermode_id]
    end
  end
end
