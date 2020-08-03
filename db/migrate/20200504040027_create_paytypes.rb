class CreatePaytypes < ActiveRecord::Migration[6.0]
  def change
    create_table :paytypes do |t|
      t.string :paytype

      t.timestamps
    end
  end
end
