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

ActiveRecord::Schema[7.0].define(version: 2025_01_03_212533) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
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
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "client_id"
    t.bigint "task_id", null: false
    t.string "transaction_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.string "network"
    t.index ["client_id"], name: "index_payments_on_client_id"
    t.index ["task_id"], name: "index_payments_on_task_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "rating"
    t.text "comment"
    t.bigint "task_id", null: false
    t.bigint "reviewer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reviewer_id"], name: "index_reviews_on_reviewer_id"
    t.index ["task_id"], name: "index_reviews_on_task_id"
  end

  create_table "subcategories", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "minimum_price", precision: 10, scale: 2, default: "0.0", null: false
    t.index ["category_id"], name: "index_subcategories_on_category_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.decimal "budget"
    t.datetime "deadline"
    t.integer "status"
    t.bigint "client_id"
    t.bigint "freelancer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "revisions", default: 1, null: false
    t.string "category"
    t.bigint "category_id"
    t.bigint "subcategory_id"
    t.string "complexity"
    t.string "time_commitment"
    t.string "urgency"
    t.index ["category_id"], name: "index_tasks_on_category_id"
    t.index ["client_id"], name: "index_tasks_on_client_id"
    t.index ["freelancer_id"], name: "index_tasks_on_freelancer_id"
    t.index ["subcategory_id"], name: "index_tasks_on_subcategory_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "payments", "tasks"
  add_foreign_key "payments", "users"
  add_foreign_key "payments", "users", column: "client_id"
  add_foreign_key "reviews", "tasks"
  add_foreign_key "reviews", "users", column: "reviewer_id"
  add_foreign_key "subcategories", "categories"
  add_foreign_key "tasks", "categories"
  add_foreign_key "tasks", "subcategories"
  add_foreign_key "tasks", "users", column: "client_id"
  add_foreign_key "tasks", "users", column: "freelancer_id"
end
