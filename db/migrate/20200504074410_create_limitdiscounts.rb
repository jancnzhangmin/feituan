class CreateLimitdiscounts < ActiveRecord::Migration[6.0]
  def change
    create_table :limitdiscounts do |t|
      t.string :name
      t.datetime :begintime
      t.datetime :endtime
      t.integer :status
      t.text :summary
      t.integer :limittype
      t.integer :priority

      t.timestamps
    end
  end
end
