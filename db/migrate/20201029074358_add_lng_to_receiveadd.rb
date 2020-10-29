class AddLngToReceiveadd < ActiveRecord::Migration[6.0]
  def change
    add_column :receiveadds, :lng, :decimal, precision:15, scale: 12
    add_column :receiveadds, :lat, :decimal, precision:15, scale: 12
  end
end
