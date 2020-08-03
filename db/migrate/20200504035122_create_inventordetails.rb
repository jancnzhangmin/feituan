class CreateInventordetails < ActiveRecord::Migration[6.0]
  def change
    create_table :inventordetails do |t|
      t.bigint :inventor_id
      t.index :inventor_id
      t.float :currentnumber
      t.float :realnumber

      t.timestamps
    end
  end
end
