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

ActiveRecord::Schema.define(version: 2024_12_08_120947) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "fuzzystrmatch"
  enable_extension "pg_trgm"
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "account_connections", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "provider", limit: 255
    t.string "uid", limit: 255
    t.string "token", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_account_connections_on_user_id"
  end

  create_table "activity_log_comments", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.text "text"
    t.integer "activity_log_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["activity_log_id"], name: "index_activity_log_comments_on_activity_log_id"
    t.index ["user_id"], name: "index_activity_log_comments_on_user_id"
  end

  create_table "activity_log_likes", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "activity_log_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["activity_log_id"], name: "index_activity_log_likes_on_activity_log_id"
    t.index ["user_id", "activity_log_id"], name: "index_activity_log_likes_on_user_id_and_activity_log_id", unique: true
    t.index ["user_id"], name: "index_activity_log_likes_on_user_id"
  end

  create_table "activity_logs", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "participation_id"
    t.decimal "hours_spent"
    t.string "hour_measure", limit: 255
    t.integer "units_accomplished"
    t.string "units_measure", limit: 255
    t.text "comment"
    t.float "score"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "minutes"
    t.date "date"
    t.index ["participation_id"], name: "index_activity_logs_on_participation_id"
    t.index ["user_id"], name: "index_activity_logs_on_user_id"
  end

  create_table "challenges", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.date "from_date"
    t.date "to_date"
    t.string "type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "visible"
    t.text "description"
    t.integer "goal_type"
    t.string "link", limit: 255
    t.integer "time_quality_table_id"
    t.integer "unit_quality_table_id"
    t.integer "unit_type_id"
    t.index ["goal_type"], name: "index_challenges_on_goal_type"
    t.index ["time_quality_table_id"], name: "index_challenges_on_time_quality_table_id"
    t.index ["type"], name: "index_challenges_on_type"
    t.index ["unit_quality_table_id"], name: "index_challenges_on_unit_quality_table_id"
    t.index ["unit_type_id"], name: "index_challenges_on_unit_type_id"
  end

  create_table "mail_preferences", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.json "mails_enabled"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_mail_preferences_on_user_id"
  end

  create_table "participations", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "challenge_id"
    t.integer "goal_hours"
    t.integer "goal_units"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal "score", precision: 8, scale: 3
    t.index ["challenge_id"], name: "index_participations_on_challenge_id"
    t.index ["score"], name: "index_participations_on_score"
    t.index ["user_id"], name: "index_participations_on_user_id"
  end

  create_table "pg_search_documents", id: :serial, force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.integer "searchable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id"
  end

  create_table "quality_tables", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.text "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resources_comments", id: :serial, force: :cascade do |t|
    t.integer "story_id"
    t.integer "user_id"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "like_count", default: 0
    t.index ["story_id"], name: "index_resources_comments_on_story_id"
    t.index ["user_id"], name: "index_resources_comments_on_user_id"
  end

  create_table "resources_likes", id: :serial, force: :cascade do |t|
    t.string "likeable_type"
    t.integer "likeable_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["likeable_type", "likeable_id"], name: "index_resources_likes_on_likeable_type_and_likeable_id"
    t.index ["user_id"], name: "index_resources_likes_on_user_id"
  end

  create_table "resources_stories", id: :serial, force: :cascade do |t|
    t.string "url"
    t.string "title"
    t.string "short_id"
    t.integer "user_id"
    t.text "description"
    t.string "image"
    t.integer "comments_count", default: 0
    t.integer "like_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "domain_name"
    t.index ["short_id"], name: "index_resources_stories_on_short_id", unique: true
    t.index ["url"], name: "index_resources_stories_on_url", unique: true
    t.index ["user_id"], name: "index_resources_stories_on_user_id"
  end

  create_table "resources_taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.integer "story_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id", "story_id"], name: "index_resources_taggings_on_tag_id_and_story_id", unique: true
  end

  create_table "resources_tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.boolean "important"
    t.integer "tier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "weight", default: 0
    t.index ["tier"], name: "index_resources_tags_on_tier"
  end

  create_table "simple_captcha_data", id: :serial, force: :cascade do |t|
    t.string "key", limit: 40
    t.string "value", limit: 6
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["key"], name: "idx_key"
  end

  create_table "unit_types", id: :serial, force: :cascade do |t|
    t.string "key"
    t.string "action"
    t.string "singular"
    t.string "plural"
    t.string "verb_present"
    t.string "verb_past"
    t.json "texts"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_unit_types_on_key", unique: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.string "confirmation_token", limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email", limit: 255
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token", limit: 255
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name", limit: 255
    t.string "role", limit: 255
    t.string "profile_link", limit: 255
    t.string "avatar", limit: 255
    t.boolean "no_mails", default: false
    t.integer "imported_from_resources_id", comment: "user-id by former resources.hc website"
    t.text "about"
    t.datetime "gdpr_consent_given_on"
    t.boolean "blocked", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "resources_likes", "users"
  add_foreign_key "resources_stories", "users"

  create_view "activity_feed_items",  sql_definition: <<-SQL
      SELECT activity_logs.id AS searchable_id,
      'ActivityLog'::text AS searchable_type,
      participations.challenge_id,
      activity_logs.user_id,
      activity_logs.created_at
     FROM (activity_logs
       JOIN participations ON ((participations.id = activity_logs.participation_id)))
  UNION
   SELECT activity_log_comments.id AS searchable_id,
      'ActivityLog::Comment'::text AS searchable_type,
      participations.challenge_id,
      activity_log_comments.user_id,
      activity_log_comments.created_at
     FROM ((activity_log_comments
       JOIN activity_logs ON ((activity_logs.id = activity_log_comments.activity_log_id)))
       JOIN participations ON ((participations.id = activity_logs.participation_id)))
  UNION
   SELECT participations.id AS searchable_id,
      'Participation'::text AS searchable_type,
      participations.challenge_id,
      participations.user_id,
      participations.created_at
     FROM participations;
  SQL

end
