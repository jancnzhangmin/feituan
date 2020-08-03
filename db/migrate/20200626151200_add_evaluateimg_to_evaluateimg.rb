class AddEvaluateimgToEvaluateimg < ActiveRecord::Migration[6.0]
  def change
    add_column :evaluateimgs, :evaluateimg, :string
  end
end
