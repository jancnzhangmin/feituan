class CreateJoinTableProductTodaydeal < ActiveRecord::Migration[6.0]
  def change
    create_join_table :products, :todaydeals do |t|
      # t.index [:product_id, :todaydeal_id]
      # t.index [:todaydeal_id, :product_id]
    end
  end
end
