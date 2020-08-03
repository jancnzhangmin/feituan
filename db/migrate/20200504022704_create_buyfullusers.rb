class CreateBuyfullusers < ActiveRecord::Migration[6.0]
  def change
    create_table :buyfullusers do |t|
      t.bigint :buyfull_id
      t.bigint :user_id

      t.timestamps
    end
    add_index :buyfullusers , [:buyfull_id]
  end
end
