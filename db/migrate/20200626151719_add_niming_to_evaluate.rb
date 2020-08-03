class AddNimingToEvaluate < ActiveRecord::Migration[6.0]
  def change
    add_column :evaluates, :niming, :integer
  end
end
