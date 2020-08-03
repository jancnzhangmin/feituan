class CreateEvaluates < ActiveRecord::Migration[6.0]
  def change
    create_table :evaluates do |t|
      t.bigint :order_id
      t.index :order_id
      t.bigint :product_id
      t.index :product_id
      t.float :postal
      t.float :describe
      t.float :service
      t.text :summary

      t.timestamps
    end
  end
end
