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

ActiveRecord::Schema[7.0].define(version: 2023_05_24_085635) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "beneficiaries", force: :cascade do |t|
    t.string "bank_name"
    t.string "account_number"
    t.string "account_name"
    t.string "phone_number"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_beneficiaries_on_user_id"
  end

  create_table "email_otps", force: :cascade do |t|
    t.string "email"
    t.string "otp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "exchange_rates", force: :cascade do |t|
    t.string "currency"
    t.float "price"
    t.datetime "time"
    t.string "day"
    t.string "month"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fee_ranges", force: :cascade do |t|
    t.integer "start_price"
    t.integer "end_price"
    t.float "fee"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["start_price", "end_price"], name: "index_fee_ranges_on_start_price_and_end_price", unique: true
  end

  create_table "transfers", force: :cascade do |t|
    t.string "currency"
    t.string "amount"
    t.string "naira_amount"
    t.integer "exchange_rate"
    t.string "fee"
    t.string "recipient_name"
    t.text "recipient_account"
    t.string "recipient_bank"
    t.string "recipient_phone"
    t.string "reference_number"
    t.string "payment_method"
    t.string "status"
    t.datetime "processing_time", precision: nil
    t.datetime "completed_time", precision: nil
    t.datetime "rejected_time", precision: nil
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_transfers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "country"
    t.string "email"
    t.boolean "verified"
    t.string "role"
    t.string "status"
    t.string "last_login"
    t.string "password_digest"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "beneficiaries", "users"
  add_foreign_key "transfers", "users"
end
