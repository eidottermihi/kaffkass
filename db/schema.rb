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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130102153241) do

  create_table "bills", :force => true do |t|
    t.decimal  "value",         :precision => 8, :scale => 2
    t.boolean  "is_paid"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.integer  "user_id"
    t.integer  "coffee_box_id"
    t.date     "date"
  end

  create_table "coffee_boxes", :force => true do |t|
    t.string   "location"
    t.time     "time"
    t.text     "description"
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
    t.integer  "user_id"
    t.decimal  "cash_position", :precision => 8, :scale => 2, :default => 0.0
    t.decimal  "saldo",         :precision => 8, :scale => 2, :default => 0.0
  end

  create_table "consumptions", :force => true do |t|
    t.date     "day"
    t.integer  "number_of_cups"
    t.boolean  "flag_touched"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "user_id"
    t.integer  "coffee_box_id"
    t.boolean  "flag_disabled"
    t.boolean  "flag_holiday"
  end

  create_table "expenses", :force => true do |t|
    t.string   "item"
    t.decimal  "value",            :precision => 8, :scale => 2
    t.date     "date"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.integer  "user_id"
    t.integer  "coffee_box_id"
    t.boolean  "flag_abgerechnet"
  end

  create_table "holidays", :force => true do |t|
    t.date     "beginning"
    t.date     "till"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  create_table "model_of_consumptions", :force => true do |t|
    t.integer  "mo"
    t.integer  "tue"
    t.integer  "wed"
    t.integer  "th"
    t.integer  "fr"
    t.integer  "sa"
    t.integer  "su"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "user_id"
    t.integer  "coffee_box_id"
  end

  create_table "notifiers", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "participations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "coffee_box_id"
    t.boolean  "is_active"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "price_of_coffees", :force => true do |t|
    t.decimal  "price",         :precision => 8, :scale => 2
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.integer  "coffee_box_id"
    t.date     "date"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.string   "persistable_token"
    t.integer  "login_count",         :default => 0
    t.integer  "failed_login_count",  :default => 0
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.boolean  "admin"
    t.boolean  "active",              :default => false, :null => false
  end

end
