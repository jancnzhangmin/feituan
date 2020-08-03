class CreateBuycarconditions < ActiveRecord::Migration[6.0]
  def change
    create_table :buycarconditions do |t|
      t.bigint :buycar_id
      t.index :buycar_id
      t.bigint :buyparam_id
      t.string :buyparam
      t.bigint :buyoption_id
      t.string :buyoption

      t.timestamps
    end
  end
end
