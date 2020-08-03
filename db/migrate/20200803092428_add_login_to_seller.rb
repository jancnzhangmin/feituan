class AddLoginToSeller < ActiveRecord::Migration[6.0]
  def change
    add_column :sellers, :login, :string
    add_column :sellers, :password_digest, :string
  end
end
