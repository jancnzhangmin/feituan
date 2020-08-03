class CreateDelivereletemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :delivereletemplates do |t|
      t.string :temid
      t.integer :isdefault

      t.timestamps
    end
  end
end
