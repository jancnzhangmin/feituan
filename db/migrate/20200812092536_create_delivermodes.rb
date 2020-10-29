class CreateDelivermodes < ActiveRecord::Migration[6.0]
  def change
    create_table :delivermodes do |t|
      t.float :weighting
      t.integer :isdefault
      t.string :name

      t.timestamps
    end
  end
end
