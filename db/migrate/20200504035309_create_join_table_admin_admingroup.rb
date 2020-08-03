class CreateJoinTableAdminAdmingroup < ActiveRecord::Migration[6.0]
  def change
    create_join_table :admins, :admingroups do |t|
      # t.index [:admin_id, :admingroup_id]
      # t.index [:admingroup_id, :admin_id]
    end
  end
end
