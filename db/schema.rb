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

ActiveRecord::Schema.define(version: 20170101111947) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "logs", force: :cascade do |t|
    t.integer  "action"
    t.integer  "level"
    t.text     "message"
    t.jsonb    "data"
    t.inet     "ip_address"
    t.string   "link"
    t.string   "message_vars"
    t.integer  "action_user_id"
    t.integer  "loggable_id"
    t.string   "loggable_type"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["action"], name: "index_logs_on_action", using: :btree
    t.index ["action_user_id"], name: "index_logs_on_action_user_id", using: :btree
    t.index ["level"], name: "index_logs_on_level", using: :btree
    t.index ["loggable_type", "loggable_id"], name: "index_logs_on_loggable_type_and_loggable_id", using: :btree
  end

  create_table "notifications", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "kind"
    t.boolean  "read",        default: false
    t.integer  "user_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "link"
    t.string   "icon"
    t.index ["kind"], name: "index_notifications_on_kind", using: :btree
    t.index ["user_id"], name: "index_notifications_on_user_id", using: :btree
  end

  create_table "settings", force: :cascade do |t|
    t.string   "var",                   null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true, using: :btree
  end

  create_table "site_signatures", force: :cascade do |t|
    t.text     "public_key"
    t.text     "private_key"
    t.integer  "site_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["site_id"], name: "index_site_signatures_on_site_id", using: :btree
  end

  create_table "sites", force: :cascade do |t|
    t.string   "name"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "api_uid"
    t.string   "api_key"
    t.index ["api_uid"], name: "index_sites_on_api_uid", using: :btree
  end

  create_table "user_avatars", force: :cascade do |t|
    t.integer  "kind"
    t.string   "uri"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_filters", force: :cascade do |t|
    t.string   "email_provider"
    t.string   "ip_address"
    t.boolean  "blocked",        default: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.inet     "cidr_address"
  end

  create_table "user_logs", force: :cascade do |t|
    t.integer  "action"
    t.integer  "level"
    t.text     "message"
    t.text     "data"
    t.string   "ip_address"
    t.integer  "action_user_id"
    t.integer  "concerned_user_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "link"
    t.string   "message_vars"
    t.index ["action"], name: "index_user_logs_on_action", using: :btree
    t.index ["action_user_id"], name: "index_user_logs_on_action_user_id", using: :btree
    t.index ["level"], name: "index_user_logs_on_level", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "email"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",                 default: false
    t.string   "activation_digest"
    t.boolean  "activated",             default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.string   "username_lower"
    t.inet     "creation_ip_address"
    t.inet     "activation_ip_address"
    t.boolean  "blocked",               default: false
    t.boolean  "suspected",             default: false
    t.string   "suspected_note"
    t.integer  "suspected_by_id"
    t.datetime "suspected_at"
    t.integer  "blocked_by_id"
    t.datetime "blocked_at"
    t.datetime "last_seen_at"
    t.string   "time_zone",             default: "UTC"
    t.text     "description"
    t.integer  "username_renew_count",  default: 0
    t.string   "locale"
    t.boolean  "deactivated",           default: false
    t.datetime "deactivated_at"
    t.boolean  "to_be_deleted",         default: false
    t.datetime "to_be_deleted_at"
    t.string   "blocked_note"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
    t.index ["username_lower"], name: "index_users_on_username_lower", unique: true, using: :btree
  end

  create_table "users_user_filters", force: :cascade do |t|
    t.integer "user_id"
    t.integer "user_filter_id"
  end

  add_foreign_key "site_signatures", "sites"
end
