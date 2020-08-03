class CreateStatements < ActiveRecord::Migration[6.0]
  def change
    create_table :statements do |t|
      t.text :statement

      t.timestamps
    end
  end
end
