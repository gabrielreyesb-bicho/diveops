class CreateAgencies < ActiveRecord::Migration[8.1]
  def change
    create_table :agencies do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :contact_email, null: false

      t.timestamps
    end

    add_index :agencies, :slug, unique: true
  end
end
