class CreateIndepots < ActiveRecord::Migration[6.0]
  def change
    create_table :indepots do |t|
      t.string :ordernumber
      t.integer :status
      t.string :handle
      t.string :reviewer

      t.timestamps
    end
  end
end
