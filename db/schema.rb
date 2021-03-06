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

ActiveRecord::Schema.define(version: 2020_05_10_030058) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "drawings", force: :cascade do |t|
    t.bigint "participant_id", null: false
    t.text "drawing", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["participant_id"], name: "index_drawings_on_participant_id"
  end

  create_table "participants", force: :cascade do |t|
    t.bigint "round_id", null: false
    t.bigint "user_id", null: false
    t.string "participant_type"
    t.boolean "round_starter", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "prompt"
    t.string "response"
    t.index ["round_id"], name: "index_participants_on_round_id"
    t.index ["user_id"], name: "index_participants_on_user_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.string "starter_name", null: false
    t.string "round_prompt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "waiting", null: false
    t.integer "turn", default: 0, null: false
    t.integer "turn_user_id", null: false
    t.string "current_prompt"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_name", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["user_name"], name: "index_users_on_user_name", unique: true
  end

end
