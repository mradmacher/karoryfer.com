# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_08_24_084227) do

  create_table "albums", force: :cascade do |t|
    t.string "title", limit: 80, null: false
    t.integer "year", null: false
    t.integer "artist_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "license_id"
    t.string "reference", limit: 80, null: false
    t.text "donation"
    t.text "description"
    t.boolean "published", default: false, null: false
    t.string "image", limit: 255
    t.boolean "shared", default: true, null: false
    t.string "license_symbol", limit: 255
    t.index ["artist_id"], name: "albums_artist_id_index"
    t.index ["reference"], name: "albums_reference_key", unique: true
  end

  create_table "artists", force: :cascade do |t|
    t.string "name", limit: 80, null: false
    t.string "reference", limit: 80, null: false
    t.string "summary_pl", limit: 255
    t.text "description_pl"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image", limit: 255
    t.boolean "shared", default: true, null: false
    t.string "summary_en", limit: 255
    t.text "description_en"
    t.string "paypal_id"
    t.string "encrypted_paypal_secret"
    t.string "encrypted_paypal_secret_iv"
    t.string "contact_email"
    t.index ["reference"], name: "artists_reference_key", unique: true
  end

  create_table "attachments", force: :cascade do |t|
    t.integer "album_id", null: false
    t.string "file", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["album_id"], name: "attachments_album_id_index"
  end

  create_table "discounts", force: :cascade do |t|
    t.integer "whole_price"
    t.string "currency"
    t.string "reference_id"
    t.integer "release_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["reference_id"], name: "index_discounts_on_reference_id"
    t.index ["release_id"], name: "index_discounts_on_release_id"
  end

  create_table "download_events", force: :cascade do |t|
    t.string "remote_ip"
    t.integer "release_id"
    t.integer "purchase_id"
    t.datetime "created_at"
    t.index ["purchase_id"], name: "index_download_events_on_purchase_id"
    t.index ["release_id"], name: "index_download_events_on_release_id"
  end

  create_table "events", force: :cascade do |t|
    t.integer "artist_id", null: false
    t.string "title", limit: 80, null: false
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "external_urls"
    t.string "location", limit: 80
    t.integer "duration", default: 0, null: false
    t.date "event_date", null: false
    t.string "address", limit: 255
    t.string "event_time", limit: 255
    t.boolean "free_entrance", default: false, null: false
    t.string "price", limit: 255
    t.string "poster", limit: 255
    t.index ["artist_id"], name: "events_artist_id_index"
  end

  create_table "licenses", force: :cascade do |t|
    t.string "symbol", limit: 16, null: false
    t.string "version", limit: 16, null: false
    t.string "name", limit: 16, null: false
  end

  create_table "pages", force: :cascade do |t|
    t.string "reference", limit: 80, null: false
    t.string "title_pl", limit: 80, null: false
    t.text "content_pl"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "artist_id", null: false
    t.string "title_en", limit: 255
    t.text "content_en"
    t.index ["artist_id", "reference"], name: "pages_artist_reference_key", unique: true
    t.index ["artist_id"], name: "pages_artist_id_index"
  end

  create_table "posts", force: :cascade do |t|
    t.integer "artist_id", null: false
    t.string "title", limit: 80
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id"], name: "posts_artist_id_index"
  end

  create_table "purchases", force: :cascade do |t|
    t.string "ip"
    t.integer "release_id"
    t.string "payment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "downloads", default: 0
    t.string "reference_id"
    t.string "presigned_url"
    t.boolean "generate_presigned_url", default: false
    t.datetime "presigned_url_generated_at"
    t.index ["reference_id"], name: "index_purchases_on_reference_id"
    t.index ["release_id"], name: "index_purchases_on_release_id"
  end

  create_table "releases", force: :cascade do |t|
    t.integer "album_id", null: false
    t.string "format", limit: 10, null: false
    t.string "file", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "downloads", default: 0, null: false
    t.string "external_url", limit: 255
    t.boolean "for_sale"
    t.string "currency"
    t.integer "whole_price"
    t.boolean "published", default: true
    t.index ["album_id", "format"], name: "releases_album_format_key", unique: true
    t.index ["album_id"], name: "releases_album_id_index"
  end

  create_table "tracks", force: :cascade do |t|
    t.string "title", limit: 80, null: false
    t.integer "album_id", null: false
    t.integer "rank", null: false
    t.string "comment", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "file", limit: 255
    t.string "artist_name", limit: 255
    t.string "ogg_preview", limit: 255
    t.string "mp3_preview", limit: 255
    t.text "lyrics"
    t.index ["album_id"], name: "tracks_album_id_index"
  end

  create_table "users", force: :cascade do |t|
    t.string "login", limit: 32, null: false
    t.string "email", limit: 255
    t.boolean "admin", default: false, null: false
    t.string "crypted_password", limit: 255
    t.string "password_salt", limit: 255
    t.string "persistence_token", limit: 255
    t.integer "login_count", default: 0
    t.integer "failed_login_count", default: 0
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "publisher", default: false, null: false
    t.index ["login"], name: "users_login_key", unique: true
  end

  create_table "videos", force: :cascade do |t|
    t.integer "artist_id", null: false
    t.string "title", limit: 80, null: false
    t.string "url", limit: 80, null: false
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id"], name: "videos_artist_id_index"
  end

end
