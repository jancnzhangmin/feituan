class CreateTodaydeals < ActiveRecord::Migration[6.0]
  def change
    create_table :todaydeals do |t|
      t.datetime :begintime
      t.datetime :endtime

      t.timestamps
    end
  end
end
