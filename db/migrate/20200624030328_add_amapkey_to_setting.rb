class AddAmapkeyToSetting < ActiveRecord::Migration[6.0]
  def change
    add_column :settings, :amapkey, :string
  end
end
