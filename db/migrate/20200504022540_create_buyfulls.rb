class CreateBuyfulls < ActiveRecord::Migration[6.0]
  def change
    create_table :buyfulls do |t|
      t.string :name
      t.datetime :begintime
      t.datetime :endtime
      t.integer :status
      t.text :summary
      t.integer :priority
      t.integer :limittype

      t.timestamps
    end
  end
end
