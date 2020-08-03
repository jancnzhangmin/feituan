class AddKuaidisecretToSetting < ActiveRecord::Migration[6.0]
  def change
    add_column :settings, :kuaidisecret, :string
  end
end
