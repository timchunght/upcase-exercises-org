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

ActiveRecord::Schema.define(version: 20141119080725) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clones", force: true do |t|
    t.integer  "user_id",                    null: false
    t.integer  "exercise_id",                null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "parent_sha"
    t.boolean  "pending",     default: true, null: false
  end

  add_index "clones", ["exercise_id"], name: "index_clones_on_exercise_id", using: :btree
  add_index "clones", ["user_id", "exercise_id"], name: "index_clones_on_user_id_and_exercise_id", unique: true, using: :btree

  create_table "comments", force: true do |t|
    t.integer  "user_id",     null: false
    t.integer  "solution_id", null: false
    t.text     "text",        null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "location",    null: false
  end

  add_index "comments", ["solution_id"], name: "index_comments_on_solution_id", using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "exercises", force: true do |t|
    t.string "title",        null: false
    t.text   "instructions", null: false
    t.string "slug",         null: false
    t.text   "intro",        null: false
    t.string "uuid",         null: false
    t.text   "summary",      null: false
  end

  add_index "exercises", ["slug"], name: "index_exercises_on_slug", unique: true, using: :btree
  add_index "exercises", ["uuid"], name: "index_exercises_on_uuid", unique: true, using: :btree

  create_table "public_keys", force: true do |t|
    t.integer  "user_id",                    null: false
    t.text     "data",                       null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "fingerprint",                null: false
    t.boolean  "pending",     default: true, null: false
  end

  add_index "public_keys", ["pending"], name: "index_public_keys_on_pending", using: :btree
  add_index "public_keys", ["user_id"], name: "index_public_keys_on_user_id", using: :btree

  create_table "revisions", force: true do |t|
    t.text     "diff",        null: false
    t.integer  "solution_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "clone_id",    null: false
  end

  add_index "revisions", ["clone_id"], name: "index_revisions_on_clone_id", using: :btree
  add_index "revisions", ["created_at"], name: "index_revisions_on_created_at", using: :btree
  add_index "revisions", ["solution_id"], name: "index_revisions_on_solution_id", using: :btree

  create_table "solutions", force: true do |t|
    t.integer  "clone_id",                   null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "comments_count", default: 0, null: false
  end

  add_index "solutions", ["clone_id"], name: "index_solutions_on_clone_id", unique: true, using: :btree
  add_index "solutions", ["comments_count"], name: "index_solutions_on_comments_count", using: :btree

  create_table "subscriptions", force: true do |t|
    t.integer  "solution_id", null: false
    t.integer  "user_id",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscriptions", ["solution_id", "user_id"], name: "index_subscriptions_on_solution_id_and_user_id", unique: true, using: :btree
  add_index "subscriptions", ["solution_id"], name: "index_subscriptions_on_solution_id", using: :btree
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "email",                                          null: false
    t.string   "encrypted_password", limit: 128
    t.string   "confirmation_token", limit: 128
    t.string   "remember_token",     limit: 128,                 null: false
    t.integer  "upcase_uid",                                     null: false
    t.string   "auth_token",                                     null: false
    t.string   "first_name",                                     null: false
    t.string   "last_name",                                      null: false
    t.boolean  "subscriber",                     default: false, null: false
    t.boolean  "admin",                          default: false
    t.string   "username"
    t.string   "avatar_url",                                     null: false
  end

  add_index "users", ["created_at"], name: "index_users_on_created_at", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree
  add_index "users", ["upcase_uid"], name: "index_users_on_upcase_uid", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
