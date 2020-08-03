class AddDepositToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :deposit, :float
  end
end
