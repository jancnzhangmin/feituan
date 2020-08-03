class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.bigint :paytype_id
      t.string :ordernumber
      t.integer :paystatus
      t.datetime :paytime
      t.integer :deliverstatus
      t.datetime :delivertime
      t.integer :receivestatus
      t.datetime :receivetime
      t.integer :evaluatestatus
      t.datetime :evaluatetime
      t.integer :status
      t.text :summary
      t.float :amount

      t.timestamps
    end
  end
end
