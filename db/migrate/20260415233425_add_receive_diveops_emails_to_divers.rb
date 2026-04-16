class AddReceiveDiveopsEmailsToDivers < ActiveRecord::Migration[8.1]
  def change
    add_column :divers, :receive_diveops_emails, :boolean, default: true, null: false
  end
end
