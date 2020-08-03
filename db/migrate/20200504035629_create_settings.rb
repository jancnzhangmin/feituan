class CreateSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :settings do |t|
      t.string :wxappid
      t.string :wxappsecret
      t.integer :autooutdepot
      t.integer :receivetime
      t.integer :evaluatetime

      t.timestamps
    end
  end
end
