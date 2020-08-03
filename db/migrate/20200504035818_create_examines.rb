class CreateExamines < ActiveRecord::Migration[6.0]
  def change
    create_table :examines do |t|
      t.datetime :begintime
      t.datetime :endtime
      t.integer :examinestatus
      t.integer :status

      t.timestamps
    end
  end
end
