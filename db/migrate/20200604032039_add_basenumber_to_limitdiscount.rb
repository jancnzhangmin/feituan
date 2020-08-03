class AddBasenumberToLimitdiscount < ActiveRecord::Migration[6.0]
  def change
    add_column :limitdiscounts, :basenumber, :float
  end
end
