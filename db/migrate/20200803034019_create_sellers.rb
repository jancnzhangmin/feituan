class CreateSellers < ActiveRecord::Migration[6.0]
  def change
    create_table :sellers do |t|
      t.string :name
      t.string :address
      t.decimal :lng, precision:15, scale: 12
      t.decimal :lat, precision:15, scale: 12
      t.integer :status
      t.string :cover
      t.text :summary

      t.timestamps
    end
  end
end
