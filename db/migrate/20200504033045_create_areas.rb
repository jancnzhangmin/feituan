class CreateAreas < ActiveRecord::Migration[6.0]
  def change
    create_table :areas do |t|
      t.string :name
      t.string :adcode
      t.decimal :lng, precision:15, scale: 12
      t.decimal :lat, precision:15, scale: 12

      t.timestamps
    end
  end
end
