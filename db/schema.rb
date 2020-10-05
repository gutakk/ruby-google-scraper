# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_05_053431) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "adword_links", force: :cascade do |t|
    t.bigint "keyword_id"
    t.string "link"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["keyword_id"], name: "index_adword_links_on_keyword_id"
  end

  create_table "keywords", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "keyword", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_keywords_on_user_id"
  end

  create_table "non_adword_links", force: :cascade do |t|
    t.bigint "keyword_id"
    t.string "link"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["keyword_id"], name: "index_non_adword_links_on_keyword_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["username"], name: "index_users_on_username"
    t.index ["username"], name: "unique_users_on_username", unique: true
  end

  add_foreign_key "adword_links", "keywords"
  add_foreign_key "keywords", "users"
  add_foreign_key "non_adword_links", "keywords"
end
