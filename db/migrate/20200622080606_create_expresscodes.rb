class CreateExpresscodes < ActiveRecord::Migration[6.0]
  def change
    create_table :expresscodes do |t|
      t.string :company
      t.string :comcode
      t.string :summary

      t.timestamps
    end
  end
end
