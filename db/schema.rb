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

ActiveRecord::Schema.define(version: 20160603174856) do

  create_table "departments", force: :cascade do |t|
    t.integer "tribe_id",             null: false
    t.string  "name",     limit: 255
  end

  add_index "departments", ["tribe_id"], name: "index_departments_on_tribe_id"

  create_table "users", force: :cascade do |t|
    t.integer "tribe_id",                 null: false
    t.string  "email",         limit: 64, null: false
    t.string  "full_name",     limit: 32, null: false
    t.string  "title",         limit: 64
    t.integer "manager_id"
    t.integer "department_id"
  end

  add_index "users", ["department_id"], name: "index_users_on_department_id"
  add_index "users", ["email"], name: "index_users_on_email"
  add_index "users", ["manager_id"], name: "index_users_on_manager_id"
  add_index "users", ["tribe_id"], name: "index_users_on_tribe_id"

end
