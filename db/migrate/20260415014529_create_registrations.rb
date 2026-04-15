class CreateRegistrations < ActiveRecord::Migration[8.1]
  def change
    create_table :registrations do |t|
      t.references :program, polymorphic: true, null: false
      t.references :diver, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.string :utm_source
      t.string :utm_medium
      t.string :utm_campaign
      t.string :utm_content
      t.text :notes

      t.timestamps
    end

    add_index :registrations,
              %i[program_type program_id diver_id],
              unique: true,
              name: "index_registrations_on_program_and_diver"
  end
end
