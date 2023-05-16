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

ActiveRecord::Schema[7.0].define(version: 2023_05_15_181000) do
  create_table "companies", force: :cascade do |t|
    t.string "email", null: false
    t.string "name", null: false
    t.string "password_digest"
    t.integer "uic", null: false
    t.string "address", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "company_contractors", force: :cascade do |t|
    t.integer "company_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_company_contractors_on_company_id"
    t.index ["user_id"], name: "index_company_contractors_on_user_id"
  end

  create_table "cranes", force: :cascade do |t|
    t.string "status"
    t.date "registration_date"
    t.string "serial_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "load_capacity"
    t.integer "year_of_manufacture"
    t.integer "application_number"
    t.date "application_date"
    t.date "last_check_date"
    t.date "next_check_date"
    t.date "suspension_date"
    t.date "scrap_date"
    t.string "crane_type"
    t.string "user"
    t.string "user_address"
    t.string "manufacturer"
    t.string "location"
    t.string "registration_number"
    t.text "notes"
    t.integer "contractor_number"
  end

  create_table "loggings", force: :cascade do |t|
    t.integer "user_id"
    t.integer "company_id"
    t.string "action"
    t.text "message"
    t.string "url"
    t.string "browser"
    t.datetime "executed_at", null: false
    t.index ["company_id"], name: "index_loggings_on_company_id"
    t.index ["user_id"], name: "index_loggings_on_user_id"
  end

  create_table "smtp_settings", force: :cascade do |t|
    t.integer "user_id"
    t.integer "company_id"
    t.string "address"
    t.integer "port"
    t.string "user_name"
    t.string "password"
    t.string "authentication"
    t.boolean "enable_starttls_auto"
    t.string "openssl_verify_mode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_smtp_settings_on_company_id"
    t.index ["user_id"], name: "index_smtp_settings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest"
    t.integer "company_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
  end

  add_foreign_key "company_contractors", "companies"
  add_foreign_key "company_contractors", "users"
  add_foreign_key "loggings", "companies"
  add_foreign_key "loggings", "users"
  add_foreign_key "smtp_settings", "companies"
  add_foreign_key "smtp_settings", "users"
end
