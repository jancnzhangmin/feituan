class AddOutdepotstatusToOrderdetail < ActiveRecord::Migration[6.0]
  def change
    add_column :orderdetails, :outdepotstatus, :integer
  end
end
