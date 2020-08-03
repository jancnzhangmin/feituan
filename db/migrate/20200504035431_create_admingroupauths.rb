class CreateAdmingroupauths < ActiveRecord::Migration[6.0]
  def change
    create_table :admingroupauths do |t|
      t.bigint :admingroup_id
      t.index :admingroup_id
      t.bigint :auth_id
      t.index :auth_id
      t.integer :level

      t.timestamps
    end
  end
end
