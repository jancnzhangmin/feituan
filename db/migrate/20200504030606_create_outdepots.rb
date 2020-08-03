class CreateOutdepots < ActiveRecord::Migration[6.0]
  def change
    create_table :outdepots do |t|
      t.string :ordernumber
      t.string :relordernumber
      t.string :handle
      t.string :reviewer
      t.integer :status

      t.timestamps
    end
  end
end
