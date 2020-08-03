class CreateOrderprints < ActiveRecord::Migration[6.0]
  def change
    create_table :orderprints do |t|
      t.string :username
      t.string :userphone
      t.string :ordernumber
      t.string :province
      t.string :city
      t.string :district
      t.string :address
      t.string :adcode
      t.string :sendaddress
      t.string :senduser
      t.string :sendphone
      t.string :receiveuser
      t.string :receivephone
      t.text :summary

      t.timestamps
    end
  end
end
