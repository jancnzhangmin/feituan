class AddSummaryToUserincome < ActiveRecord::Migration[6.0]
  def change
    add_column :userincomes, :summary, :string
  end
end
