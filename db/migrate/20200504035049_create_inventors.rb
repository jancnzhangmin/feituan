class CreateInventors < ActiveRecord::Migration[6.0]
  def change
    create_table :inventors do |t|
      t.string :ordernumber
      t.string :handle
      t.string :reviewer
      t.text :summary
      t.integer :status
      t.float :currentcost
      t.float :realcost

      t.timestamps
    end
  end
end
