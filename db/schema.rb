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

ActiveRecord::Schema.define(version: 2021_09_13_211950) do

  create_table "users", force: :cascade do |t|
    t.string "full_name"
    t.string "email", null: false
    t.string "username", null: false
    t.string "password_digest", null: false
    t.boolean "email_confirmed", default: false
    t.string "confirm_token"
    t.text "bio"
    t.string "gender"
    t.string "website"
    t.boolean "is_owner", default: false
    t.boolean "is_admin", default: false
    t.boolean "is_writer", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
