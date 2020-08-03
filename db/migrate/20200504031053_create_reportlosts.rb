class CreateReportlosts < ActiveRecord::Migration[6.0]
  def change
    create_table :reportlosts do |t|
      t.string :ordernumber
      t.string :handle
      t.string :reviewer
      t.text :summary
      t.integer :status

      t.timestamps
    end
  end
end
