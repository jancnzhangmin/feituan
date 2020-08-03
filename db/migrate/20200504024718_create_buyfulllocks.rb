class CreateBuyfulllocks < ActiveRecord::Migration[6.0]
  def change
    create_table :buyfulllocks do |t|
      t.bigint :buyfullgiveproduct_id
      t.float :number
      t.string :ordernumber

      t.timestamps
    end
    add_index :buyfulllocks , [:buyfullgiveproduct_id]
  end
end
