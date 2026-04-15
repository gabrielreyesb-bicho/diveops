class CreateDiveTrips < ActiveRecord::Migration[8.1]
  def change
    create_table :dive_trips do |t|
      t.references :agency, null: false, foreign_key: true
      t.string :title
      t.text :destination
      t.date :departure_date
      t.date :return_date
      t.integer :max_capacity
      t.integer :min_capacity
      t.decimal :base_price, precision: 12, scale: 2
      t.integer :status, null: false, default: 0
      t.text :cancellation_reason

      t.timestamps
    end
  end
end
