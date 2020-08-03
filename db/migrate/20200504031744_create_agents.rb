class CreateAgents < ActiveRecord::Migration[6.0]
  def change
    create_table :agents do |t|
      t.string :name
      t.float :price
      t.float :deposit
      t.float :task
      t.bigint :corder

      t.timestamps
    end
  end
end
