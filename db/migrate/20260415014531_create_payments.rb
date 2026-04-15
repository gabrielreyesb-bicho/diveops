class CreatePayments < ActiveRecord::Migration[8.1]
  def change
    create_table :payments do |t|
      t.references :registration, null: false, foreign_key: true
      t.decimal :amount, precision: 12, scale: 2, null: false
      t.integer :payment_method, null: false
      t.string :stripe_payment_intent_id
      t.integer :status, null: false, default: 0
      t.datetime :paid_at
      t.text :notes

      t.timestamps
    end
  end
end
