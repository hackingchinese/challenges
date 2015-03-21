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

ActiveRecord::Schema.define(version: 20150321203549) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_connections", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "account_connections", ["user_id"], name: "index_account_connections_on_user_id", using: :btree

  create_table "activity_logs", force: true do |t|
    t.integer  "user_id"
    t.integer  "participation_id"
    t.decimal  "hours_spent"
    t.string   "hour_measure"
    t.integer  "units_accomplished"
    t.string   "units_measure"
    t.text     "comment"
    t.float    "score"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "minutes"
    t.date     "date"
  end

  add_index "activity_logs", ["participation_id"], name: "index_activity_logs_on_participation_id", using: :btree
  add_index "activity_logs", ["user_id"], name: "index_activity_logs_on_user_id", using: :btree

  create_table "challenges", force: true do |t|
    t.string   "title"
    t.date     "from_date"
    t.date     "to_date"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "visible"
    t.text     "description"
    t.integer  "goal_type"
    t.string   "unit"
    t.string   "link"
    t.integer  "time_quality_table_id"
    t.integer  "unit_quality_table_id"
  end

  add_index "challenges", ["goal_type"], name: "index_challenges_on_goal_type", using: :btree
  add_index "challenges", ["time_quality_table_id"], name: "index_challenges_on_time_quality_table_id", using: :btree
  add_index "challenges", ["type"], name: "index_challenges_on_type", using: :btree
  add_index "challenges", ["unit_quality_table_id"], name: "index_challenges_on_unit_quality_table_id", using: :btree

  create_table "participations", force: true do |t|
    t.integer  "user_id"
    t.integer  "challenge_id"
    t.integer  "goal_hours"
    t.integer  "goal_units"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "score",        precision: 8, scale: 3
  end

  add_index "participations", ["challenge_id"], name: "index_participations_on_challenge_id", using: :btree
  add_index "participations", ["score"], name: "index_participations_on_score", using: :btree
  add_index "participations", ["user_id"], name: "index_participations_on_user_id", using: :btree

  create_table "quality_tables", force: true do |t|
    t.string   "name"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "simple_captcha_data", force: true do |t|
    t.string   "key",        limit: 40
    t.string   "value",      limit: 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "simple_captcha_data", ["key"], name: "idx_key", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,     null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "role"
    t.string   "profile_link"
    t.string   "avatar"
    t.boolean  "no_mails",               default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["name"], name: "index_users_on_name", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
