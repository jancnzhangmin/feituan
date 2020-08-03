class AddOnhomeToProductcla < ActiveRecord::Migration[6.0]
  def change
    add_column :productclas, :onhome, :integer
  end
end
