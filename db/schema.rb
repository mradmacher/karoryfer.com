# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20170608152341) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "albums", force: true do |t|
    t.string   "title",          limit: 80,                   null: false
    t.integer  "year",                                        null: false
    t.integer  "artist_id",                                   null: false
    t.datetime "created_at",                default: "now()", null: false
    t.datetime "updated_at",                default: "now()", null: false
    t.integer  "license_id"
    t.string   "reference",      limit: 80,                   null: false
    t.text     "donation"
    t.text     "description"
    t.boolean  "published",                 default: false,   null: false
    t.string   "image"
    t.boolean  "shared",                    default: true,    null: false
    t.string   "license_symbol"
  end

  add_index "albums", ["artist_id"], name: "albums_artist_id_index", using: :btree
  add_index "albums", ["reference"], name: "albums_reference_key", unique: true, using: :btree

  create_table "artists", force: true do |t|
    t.string   "name",        limit: 80,                   null: false
    t.string   "reference",   limit: 80,                   null: false
    t.string   "summary"
    t.text     "description"
    t.datetime "created_at",             default: "now()", null: false
    t.datetime "updated_at",             default: "now()", null: false
    t.string   "image"
    t.boolean  "shared",                 default: true,    null: false
  end

  add_index "artists", ["reference"], name: "artists_reference_key", unique: true, using: :btree

  create_table "attachments", force: true do |t|
    t.integer  "album_id",                     null: false
    t.string   "file",                         null: false
    t.datetime "created_at", default: "now()", null: false
    t.datetime "updated_at", default: "now()", null: false
  end

  add_index "attachments", ["album_id"], name: "attachments_album_id_index", using: :btree

  create_table "events", force: true do |t|
    t.integer  "artist_id",                                  null: false
    t.string   "title",         limit: 80,                   null: false
    t.text     "body"
    t.datetime "created_at",               default: "now()", null: false
    t.datetime "updated_at",               default: "now()", null: false
    t.text     "external_urls"
    t.string   "location",      limit: 80
    t.integer  "duration",                 default: 0,       null: false
    t.date     "event_date",                                 null: false
    t.string   "address"
    t.string   "event_time"
    t.boolean  "free_entrance",            default: false,   null: false
    t.string   "price"
    t.string   "poster"
  end

  add_index "events", ["artist_id"], name: "events_artist_id_index", using: :btree

  create_table "licenses", force: true do |t|
    t.string "symbol",  limit: 16, null: false
    t.string "version", limit: 16, null: false
    t.string "name",    limit: 16, null: false
  end

  create_table "memberships", force: true do |t|
    t.integer "artist_id", null: false
    t.integer "user_id",   null: false
  end

  add_index "memberships", ["artist_id"], name: "memberships_artist_id_index", using: :btree
  add_index "memberships", ["user_id"], name: "memberships_user_id_index", using: :btree

  create_table "pages", force: true do |t|
    t.string   "reference",  limit: 80,                   null: false
    t.string   "title",      limit: 80,                   null: false
    t.text     "content"
    t.datetime "created_at",            default: "now()", null: false
    t.datetime "updated_at",            default: "now()", null: false
    t.integer  "artist_id",                               null: false
  end

  add_index "pages", ["artist_id", "reference"], name: "pages_artist_reference_key", unique: true, using: :btree
  add_index "pages", ["artist_id"], name: "pages_artist_id_index", using: :btree

  create_table "posts", force: true do |t|
    t.integer  "artist_id",                               null: false
    t.string   "title",      limit: 80
    t.text     "body"
    t.datetime "created_at",            default: "now()", null: false
    t.datetime "updated_at",            default: "now()", null: false
  end

  add_index "posts", ["artist_id"], name: "posts_artist_id_index", using: :btree

  create_table "releases", force: true do |t|
    t.integer  "album_id",                                  null: false
    t.string   "format",       limit: 10,                   null: false
    t.string   "file"
    t.datetime "created_at",              default: "now()", null: false
    t.datetime "updated_at",              default: "now()", null: false
    t.integer  "downloads",               default: 0,       null: false
    t.string   "bandcamp_url"
  end

  add_index "releases", ["album_id", "format"], name: "releases_album_format_key", unique: true, using: :btree
  add_index "releases", ["album_id"], name: "releases_album_id_index", using: :btree

  create_table "tracks", force: true do |t|
    t.string   "title",       limit: 80,                   null: false
    t.integer  "album_id",                                 null: false
    t.integer  "rank",                                     null: false
    t.string   "comment"
    t.datetime "created_at",             default: "now()", null: false
    t.datetime "updated_at",             default: "now()", null: false
    t.string   "file"
    t.string   "artist_name"
    t.string   "ogg_preview"
    t.string   "mp3_preview"
  end

  add_index "tracks", ["album_id"], name: "tracks_album_id_index", using: :btree

  create_table "users", force: true do |t|
    t.string   "login",              limit: 32,                   null: false
    t.string   "email"
    t.boolean  "admin",                         default: false,   null: false
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.integer  "login_count",                   default: 0
    t.integer  "failed_login_count",            default: 0
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.datetime "created_at",                    default: "now()", null: false
    t.datetime "updated_at",                    default: "now()", null: false
    t.boolean  "publisher",                     default: false,   null: false
  end

  add_index "users", ["login"], name: "users_login_key", unique: true, using: :btree

  create_table "videos", force: true do |t|
    t.integer  "artist_id",                               null: false
    t.string   "title",      limit: 80,                   null: false
    t.string   "url",        limit: 80,                   null: false
    t.text     "body"
    t.datetime "created_at",            default: "now()", null: false
    t.datetime "updated_at",            default: "now()", null: false
  end

  add_index "videos", ["artist_id"], name: "videos_artist_id_index", using: :btree

end
