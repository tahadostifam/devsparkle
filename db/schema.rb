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

ActiveRecord::Schema.define(version: 2021_10_27_121941) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.integer "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "articles", force: :cascade do |t|
    t.string "slug", null: false
    t.string "header", null: false
    t.text "content", null: false
    t.text "cover_text"
    t.boolean "published", default: false
    t.string "published_time"
    t.boolean "draft", default: false
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "image_file_name"
    t.integer "image_file_size"
    t.string "image_content_type"
    t.datetime "image_updated_at"
    t.index ["user_id"], name: "index_articles_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "article_id", null: false
    t.string "content", null: false
    t.string "send_time", null: false
    t.string "hash_id", null: false
    t.boolean "accept_by_admin", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["article_id"], name: "index_comments_on_article_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "course_episodes", force: :cascade do |t|
    t.string "slug", null: false
    t.string "header", null: false
    t.text "cover_text"
    t.boolean "published", default: false
    t.integer "course_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "video_file_file_name"
    t.integer "video_file_file_size"
    t.string "video_file_content_type"
    t.datetime "video_file_updated_at"
    t.index ["course_id"], name: "index_course_episodes_on_course_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "slug", null: false
    t.string "header", null: false
    t.text "cover_text"
    t.boolean "published", default: false
    t.boolean "course_finish_state", default: false
    t.integer "price", default: 0
    t.string "published_time"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_courses_on_user_id"
  end

  create_table "likes", force: :cascade do |t|
    t.integer "article_id"
    t.integer "user_id"
    t.index ["article_id"], name: "index_likes_on_article_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "about_us"
    t.string "tac"
    t.boolean "can_comment"
  end

  create_table "users", force: :cascade do |t|
    t.string "full_name"
    t.string "email", null: false
    t.string "username", null: false
    t.string "password_digest", null: false
    t.boolean "email_confirmed", default: false
    t.text "bio"
    t.string "gender"
    t.string "website"
    t.boolean "is_owner", default: false
    t.boolean "is_admin", default: false
    t.boolean "is_banned", default: false
    t.string "confirm_token"
    t.string "forgot_password_token"
    t.string "forgot_password_expire_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
