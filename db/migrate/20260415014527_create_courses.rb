class CreateCourses < ActiveRecord::Migration[8.1]
  def change
    create_table :courses do |t|
      t.references :agency, null: false, foreign_key: true
      t.string :title
      t.string :certification_granted
      t.string :prerequisite_certification
      t.date :start_date
      t.date :end_date
      t.string :duration_description
      t.integer :max_capacity
      t.integer :min_capacity
      t.decimal :base_price, precision: 12, scale: 2
      t.integer :status, null: false, default: 0
      t.text :cancellation_reason

      t.timestamps
    end
  end
end
