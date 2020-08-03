class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :subname
      t.string :barcode
      t.float :number
      t.float :weight
      t.text :content
      t.integer :onsale
      t.integer :presale
      t.float :price
      t.string :unit
      t.string :pinyin
      t.string :fullpinyin
      t.integer :trial

      t.timestamps
    end
  end
end
