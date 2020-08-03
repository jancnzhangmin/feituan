class CreateReportoverflows < ActiveRecord::Migration[6.0]
  def change
    create_table :reportoverflows do |t|
      t.string :ordernumber
      t.text :summary
      t.string :handle
      t.string :reviewer
      t.integer :status

      t.timestamps
    end
  end
end
