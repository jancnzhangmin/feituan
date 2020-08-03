class AddOrdernumberToCharge < ActiveRecord::Migration[6.0]
  def change
    add_column :charges, :ordernumber, :string
    add_column :charges, :summary, :string
  end
end
