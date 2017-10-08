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

ActiveRecord::Schema.define(version: 20171001161607) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_keys", force: :cascade do |t|
    t.string "label"
    t.string "public_key"
    t.string "secret_key"
    t.bigint "site_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["public_key"], name: "index_api_keys_on_public_key"
    t.index ["site_id"], name: "index_api_keys_on_site_id"
  end

  create_table "auth_accounts", force: :cascade do |t|
    t.string "provider", limit: 100
    t.string "uid"
    t.string "name"
    t.string "nickname"
    t.string "image_url"
    t.string "email"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid", "provider"], name: "index_auth_accounts_on_uid_and_provider", unique: true
    t.index ["user_id"], name: "index_auth_accounts_on_user_id"
  end

  create_table "logs", force: :cascade do |t|
    t.integer "action"
    t.integer "level"
    t.text "message"
    t.jsonb "data"
    t.inet "ip_address"
    t.string "link"
    t.string "message_vars"
    t.integer "action_user_id"
    t.string "loggable_type"
    t.bigint "loggable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action"], name: "index_logs_on_action"
    t.index ["action_user_id"], name: "index_logs_on_action_user_id"
    t.index ["level"], name: "index_logs_on_level"
    t.index ["loggable_type", "loggable_id"], name: "index_logs_on_loggable_type_and_loggable_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "kind"
    t.boolean "read", default: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "link"
    t.string "icon"
    t.index ["kind"], name: "index_notifications_on_kind"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "refresh_tokens", force: :cascade do |t|
    t.string "token"
    t.integer "platform"
    t.bigint "user_id"
    t.datetime "blocked_at"
    t.string "blocked_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token", "user_id"], name: "index_refresh_tokens_on_token_and_user_id", unique: true
    t.index ["user_id"], name: "index_refresh_tokens_on_user_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "var", null: false
    t.text "value"
    t.integer "thing_id"
    t.string "thing_type", limit: 30
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true
  end

  create_table "sites", force: :cascade do |t|
    t.string "name"
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_avatars", force: :cascade do |t|
    t.integer "kind"
    t.string "uri"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_filters", force: :cascade do |t|
    t.string "email_provider"
    t.string "ip_address"
    t.boolean "blocked", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.inet "cidr_address"
  end

  create_table "user_logs", force: :cascade do |t|
    t.integer "action"
    t.integer "level"
    t.text "message"
    t.text "data"
    t.string "ip_address"
    t.integer "action_user_id"
    t.integer "concerned_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "link"
    t.string "message_vars"
    t.index ["action"], name: "index_user_logs_on_action"
    t.index ["action_user_id"], name: "index_user_logs_on_action_user_id"
    t.index ["level"], name: "index_user_logs_on_level"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.string "username_lower"
    t.inet "creation_ip_address"
    t.inet "activation_ip_address"
    t.boolean "blocked", default: false
    t.boolean "suspected", default: false
    t.string "suspected_note"
    t.integer "suspected_by_id"
    t.datetime "suspected_at"
    t.integer "blocked_by_id"
    t.datetime "blocked_at"
    t.datetime "last_seen_at"
    t.string "time_zone", default: "UTC"
    t.text "description"
    t.integer "username_renew_count", default: 0
    t.string "locale"
    t.boolean "deactivated", default: false
    t.datetime "deactivated_at"
    t.boolean "to_be_deleted", default: false
    t.datetime "to_be_deleted_at"
    t.string "blocked_note"
    t.string "creation_domain"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
    t.index ["username_lower"], name: "index_users_on_username_lower", unique: true
  end

  create_table "users_user_filters", force: :cascade do |t|
    t.integer "user_id"
    t.integer "user_filter_id"
  end

  add_foreign_key "auth_accounts", "users"
  add_foreign_key "refresh_tokens", "users"
end
