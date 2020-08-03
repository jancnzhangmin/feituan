class AddBuyparamoptionimgToBuyparamoption < ActiveRecord::Migration[6.0]
  def change
    add_column :buyparamoptions, :buyparamoptionimg, :string
  end
end
