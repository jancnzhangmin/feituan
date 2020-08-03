class CreateReportoverflowdetails < ActiveRecord::Migration[6.0]
  def change
    create_table :reportoverflowdetails do |t|
      t.bigint :reportoverflow_id
      t.index :reportoverflow_id
      t.bigint :product_id
      t.index :product_id
      t.bigint :buyparamoption_id
      t.index :buyparamoption_id
      t.float :number
      t.text :summary

      t.timestamps
    end
  end
end
