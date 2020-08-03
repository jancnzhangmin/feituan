class CreatePostalpolicareas < ActiveRecord::Migration[6.0]
  def change
    create_table :postalpolicareas do |t|
      t.bigint :postalpolic_id
      t.index :postalpolic_id
      t.string :name
      t.string :adcode

      t.timestamps
    end
  end
end
