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

ActiveRecord::Schema[7.1].define(version: 2024_06_19_082842) do
  create_table "bot_trades", force: :cascade do |t|
    t.integer "user_id"
    t.string "symbol"
    t.string "trade_type"
    t.decimal "price"
    t.integer "quantity"
    t.string "status"
    t.datetime "transaction_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settings", force: :cascade do |t|
    t.string "endpoint"
    t.string "key_id"
    t.string "key_secret"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "broker"
    t.index ["user_id"], name: "index_settings_on_user_id"
  end

  create_table "trades", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.decimal "initial_portfolio_value", null: false
    t.decimal "final_portfolio_value"
    t.string "status", null: false
    t.string "symbol", null: false
    t.integer "quantity", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "string"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "email"
  end

  add_foreign_key "settings", "users"
end
