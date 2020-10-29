class CreateExchangerates < ActiveRecord::Migration[6.0]
  def change
    create_table :exchangerates do |t|
      t.float :rate

      t.timestamps
    end
  end
end
