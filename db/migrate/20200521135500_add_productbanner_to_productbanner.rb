class AddProductbannerToProductbanner < ActiveRecord::Migration[6.0]
  def change
    add_column :productbanners, :productbanner, :string
  end
end
