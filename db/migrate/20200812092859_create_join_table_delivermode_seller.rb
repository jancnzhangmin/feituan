class CreateJoinTableDelivermodeSeller < ActiveRecord::Migration[6.0]
  def change
    create_join_table :delivermodes, :sellers do |t|
       t.index [:delivermode_id, :seller_id]
       t.index [:seller_id, :delivermode_id]
    end
  end
end
