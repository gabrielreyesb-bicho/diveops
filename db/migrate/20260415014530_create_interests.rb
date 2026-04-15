class CreateInterests < ActiveRecord::Migration[8.1]
  def change
    create_table :interests do |t|
      t.references :program, polymorphic: true, null: false
      t.references :diver, null: false, foreign_key: true

      t.timestamps
    end

    add_index :interests,
              %i[program_type program_id diver_id],
              unique: true,
              name: "index_interests_on_program_and_diver"
  end
end
