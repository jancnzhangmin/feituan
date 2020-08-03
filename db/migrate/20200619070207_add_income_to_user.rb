class AddIncomeToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :income, :float
  end
end
