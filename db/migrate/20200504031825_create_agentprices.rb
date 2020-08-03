class CreateAgentprices < ActiveRecord::Migration[6.0]
  def change
    create_table :agentprices do |t|
      t.bigint :product_id
      t.index :product_id
      t.bigint :agent_id
      t.index :agent_id
      t.float :price

      t.timestamps
    end
  end
end
