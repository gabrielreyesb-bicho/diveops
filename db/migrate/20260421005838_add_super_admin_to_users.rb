class AddSuperAdminToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :super_admin, :boolean, default: false, null: false
    change_column_null :users, :agency_id, true
  end
end
