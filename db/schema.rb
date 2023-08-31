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

ActiveRecord::Schema[7.0].define(version: 2023_08_30_095326) do
  create_table "annual_leave_requests", force: :cascade do |t|
    t.string "status", default: "pending"
    t.date "date_from"
    t.date "date_to"
    t.decimal "days_required"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_annual_leave_requests_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "given_name", null: false
    t.string "family_name", null: false
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "role", default: "user"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "annual_leave_remaining", precision: 3, scale: 1, default: "25.0", null: false
    t.integer "line_manager_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["line_manager_id"], name: "index_users_on_line_manager_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "annual_leave_requests", "users"
  add_foreign_key "users", "users", column: "line_manager_id"
end
