# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_04_15_233425) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "agencies", force: :cascade do |t|
    t.string "contact_email", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_agencies_on_slug", unique: true
  end

  create_table "courses", force: :cascade do |t|
    t.bigint "agency_id", null: false
    t.decimal "base_price", precision: 12, scale: 2
    t.text "cancellation_reason"
    t.string "certification_granted"
    t.datetime "created_at", null: false
    t.string "duration_description"
    t.date "end_date"
    t.integer "max_capacity"
    t.integer "min_capacity"
    t.string "prerequisite_certification"
    t.date "start_date"
    t.integer "status", default: 0, null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["agency_id"], name: "index_courses_on_agency_id"
  end

  create_table "dive_trips", force: :cascade do |t|
    t.bigint "agency_id", null: false
    t.decimal "base_price", precision: 12, scale: 2
    t.text "cancellation_reason"
    t.datetime "created_at", null: false
    t.date "departure_date"
    t.text "destination"
    t.integer "max_capacity"
    t.integer "min_capacity"
    t.date "return_date"
    t.integer "status", default: 0, null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["agency_id"], name: "index_dive_trips_on_agency_id"
  end

  create_table "divers", force: :cascade do |t|
    t.integer "certification_level", default: 0, null: false
    t.datetime "created_at", null: false
    t.integer "dive_count"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.string "phone"
    t.integer "privacy", default: 0, null: false
    t.integer "provider", default: 1, null: false
    t.boolean "receive_diveops_emails", default: true, null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "uid"
    t.datetime "updated_at", null: false
    t.string "utm_campaign"
    t.string "utm_content"
    t.string "utm_medium"
    t.string "utm_source"
    t.index ["email"], name: "index_divers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_divers_on_reset_password_token", unique: true
    t.index ["uid"], name: "index_divers_on_uid", unique: true, where: "(uid IS NOT NULL)"
  end

  create_table "interests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "diver_id", null: false
    t.bigint "program_id", null: false
    t.string "program_type", null: false
    t.datetime "updated_at", null: false
    t.index ["diver_id"], name: "index_interests_on_diver_id"
    t.index ["program_type", "program_id", "diver_id"], name: "index_interests_on_program_and_diver", unique: true
    t.index ["program_type", "program_id"], name: "index_interests_on_program"
  end

  create_table "payments", force: :cascade do |t|
    t.decimal "amount", precision: 12, scale: 2, null: false
    t.datetime "created_at", null: false
    t.text "notes"
    t.datetime "paid_at"
    t.integer "payment_method", null: false
    t.bigint "registration_id", null: false
    t.integer "status", default: 0, null: false
    t.string "stripe_payment_intent_id"
    t.datetime "updated_at", null: false
    t.index ["registration_id"], name: "index_payments_on_registration_id"
  end

  create_table "photos", force: :cascade do |t|
    t.bigint "attachable_id", null: false
    t.string "attachable_type", null: false
    t.datetime "created_at", null: false
    t.integer "position", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["attachable_type", "attachable_id"], name: "index_photos_on_attachable"
  end

  create_table "registrations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "diver_id", null: false
    t.text "notes"
    t.bigint "program_id", null: false
    t.string "program_type", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.string "utm_campaign"
    t.string "utm_content"
    t.string "utm_medium"
    t.string "utm_source"
    t.index ["diver_id"], name: "index_registrations_on_diver_id"
    t.index ["program_type", "program_id", "diver_id"], name: "index_registrations_on_program_and_diver", unique: true
    t.index ["program_type", "program_id"], name: "index_registrations_on_program"
  end

  create_table "users", force: :cascade do |t|
    t.bigint "agency_id", null: false
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role", default: 1, null: false
    t.datetime "updated_at", null: false
    t.index ["agency_id"], name: "index_users_on_agency_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "courses", "agencies"
  add_foreign_key "dive_trips", "agencies"
  add_foreign_key "interests", "divers"
  add_foreign_key "payments", "registrations"
  add_foreign_key "registrations", "divers"
  add_foreign_key "users", "agencies"
end
