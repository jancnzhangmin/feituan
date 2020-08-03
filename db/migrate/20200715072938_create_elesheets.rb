class CreateElesheets < ActiveRecord::Migration[6.0]
  def change
    create_table :elesheets do |t|
      t.string :partnerid
      t.string :partnerkey

      t.timestamps
    end
  end
end
