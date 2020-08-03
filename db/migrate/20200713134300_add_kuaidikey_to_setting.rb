class AddKuaidikeyToSetting < ActiveRecord::Migration[6.0]
  def change
    add_column :settings, :kuaidikey, :string
    add_column :settings, :kuaidicustomer, :string
  end
end
