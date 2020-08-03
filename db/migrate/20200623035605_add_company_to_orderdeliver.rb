class AddCompanyToOrderdeliver < ActiveRecord::Migration[6.0]
  def change
    add_column :orderdelivers, :company, :string
  end
end
