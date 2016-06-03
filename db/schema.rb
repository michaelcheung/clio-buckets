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

ActiveRecord::Schema.define(version: 20160603233147) do

  create_table "competencies", force: :cascade do |t|
    t.string  "category", limit: 16,             null: false
    t.string  "name",     limit: 16,             null: false
    t.integer "rank",                default: 0, null: false
  end

  create_table "competency_roles", force: :cascade do |t|
    t.integer "competency_id", null: false
    t.integer "role_id",       null: false
  end

  create_table "departments", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "grants", force: :cascade do |t|
    t.integer  "granter_id",           null: false
    t.integer  "secondary_granter_id"
    t.integer  "grantee_id",           null: false
    t.integer  "competency_id",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "reason"
  end

  add_index "grants", ["grantee_id"], name: "index_grants_on_grantee_id"

  create_table "roles", force: :cascade do |t|
    t.integer "department_id",            null: false
    t.string  "name",          limit: 64, null: false
  end

  add_index "roles", ["department_id"], name: "index_roles_on_department_id"

  create_table "user_roles", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "role_id", null: false
  end

  add_index "user_roles", ["role_id"], name: "index_user_roles_on_role_id"
  add_index "user_roles", ["user_id"], name: "index_user_roles_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string  "email",         limit: 64, null: false
    t.string  "full_name",     limit: 32, null: false
    t.string  "title",         limit: 64
    t.integer "manager_id"
    t.integer "department_id"
  end

  add_index "users", ["department_id"], name: "index_users_on_department_id"
  add_index "users", ["email"], name: "index_users_on_email"
  add_index "users", ["manager_id"], name: "index_users_on_manager_id"

end
