class AddContactToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :province, :string
    add_column :orders, :city, :string
    add_column :orders, :district, :string
    add_column :orders, :address, :string
    add_column :orders, :contact, :string
    add_column :orders, :phone, :string
    add_column :orders, :adcode, :string
  end
end
