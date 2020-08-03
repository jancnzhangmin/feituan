class CreateBuyparamoptions < ActiveRecord::Migration[6.0]
  def change
    create_table :buyparamoptions do |t|
      t.bigint :buyparam_id
      t.index :buyparam_id
      t.string :name
      t.float :weighting
      t.float :weight

      t.timestamps
    end
  end
end
