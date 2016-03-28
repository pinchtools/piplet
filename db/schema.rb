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

ActiveRecord::Schema.define(version: 20160328161549) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "settings", force: :cascade do |t|
    t.string   "var",                   null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true, using: :btree

  create_table "user_auth_lists", force: :cascade do |t|
    t.string   "username"
    t.string   "email"
    t.string   "email_provider"
    t.inet     "ip_address"
    t.boolean  "banned"
    t.boolean  "trusted"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "user_filters", force: :cascade do |t|
    t.string   "email_provider"
    t.string   "ip_address"
    t.boolean  "blocked"
    t.boolean  "trusted"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
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
  end

  add_index "user_logs", ["action"], name: "index_user_logs_on_action", using: :btree
  add_index "user_logs", ["action_user_id"], name: "index_user_logs_on_action_user_id", using: :btree
  add_index "user_logs", ["level"], name: "index_user_logs_on_level", using: :btree

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
    t.boolean  "blocked"
    t.boolean  "suspected"
    t.string   "suspected_note"
    t.integer  "suspected_by_id"
    t.datetime "suspected_at"
    t.integer  "blocked_by_id"
    t.datetime "blocked_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree
  add_index "users", ["username_lower"], name: "index_users_on_username_lower", unique: true, using: :btree

  create_table "users_user_filters", force: :cascade do |t|
    t.integer "user_id"
    t.integer "user_filter_id"
  end

end
