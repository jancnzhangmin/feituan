class AddBasenumberToLimitdiscountproduct < ActiveRecord::Migration[6.0]
  def change
    add_column :limitdiscountproducts, :basenumber, :float
  end
end
