class AddSendcontactToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :sendcontact, :string
    add_column :orders, :sendphone, :string
  end
end
