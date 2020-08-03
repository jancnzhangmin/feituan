class AddContactToSeller < ActiveRecord::Migration[6.0]
  def change
    add_column :sellers, :contact, :string
    add_column :sellers, :contactphone, :string
  end
end
