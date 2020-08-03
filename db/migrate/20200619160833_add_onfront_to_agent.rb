class AddOnfrontToAgent < ActiveRecord::Migration[6.0]
  def change
    add_column :agents, :onfront, :integer
  end
end
