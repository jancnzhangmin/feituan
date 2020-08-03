class CreateQuarters < ActiveRecord::Migration[6.0]
  def change
    create_table :quarters do |t|
      t.datetime :begintime
      t.datetime :endtime
      t.string :yearname
      t.string :name

      t.timestamps
    end
  end
end
