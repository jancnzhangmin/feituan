class CreateOrderproducts < ActiveRecord::Migration[6.0]
  def change
    create_table :orderproducts do |t|
      t.string :selfnumber
      t.string :name
      t.string :spec

      t.timestamps
    end
  end
end
