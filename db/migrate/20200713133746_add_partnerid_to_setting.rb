class AddPartneridToSetting < ActiveRecord::Migration[6.0]
  def change
    add_column :settings, :partnerid, :string
    add_column :settings, :sendmanname, :string
    add_column :settings, :sendmanmobile, :string
    add_column :settings, :sendmanprintaddr, :string
  end
end
