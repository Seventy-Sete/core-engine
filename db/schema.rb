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

ActiveRecord::Schema[7.0].define(version: 2023_01_13_164077) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "bank_details", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "reference"
    t.float "balance"
    t.float "incoming"
    t.float "outgoing"
    t.string "user_bank_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reference"], name: "index_bank_details_on_reference"
  end

  create_table "bank_transactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "user_bank_id", null: false
    t.string "title"
    t.float "amount"
    t.datetime "due_date"
    t.string "tags", default: [], array: true
    t.integer "purpose", default: 7
    t.string "transaction_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_bank_id"], name: "index_bank_transactions_on_user_bank_id"
  end

  create_table "user_banks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "bank", default: "default", null: false
    t.string "bank_name"
    t.string "user_id"
    t.string "bcn"
    t.string "access_key"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_banks_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.jsonb "email", null: false
    t.jsonb "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "feature_control", default: {}
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
