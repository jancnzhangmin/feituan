class CreateShowparams < ActiveRecord::Migration[6.0]
  def change
    create_table :showparams do |t|
      t.bigint :product_id
      t.index :product_id
      t.string :name
      t.string :param
      t.bigint :corder

      t.timestamps
    end
  end
end
