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

ActiveRecord::Schema.define(:version => 20121111130404) do

  create_table "bills", :force => true do |t|
    t.decimal  "value",         :precision => 5, :scale => 2
    t.boolean  "isPaid"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.integer  "user_id"
    t.integer  "coffee_box_id"
  end

  create_table "coffee_boxes", :force => true do |t|
    t.text     "location"
    t.datetime "time"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "user_id"
  end

  create_table "consumptions", :force => true do |t|
    t.date     "day"
    t.integer  "numberOfCups"
    t.boolean  "flagTouched"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "user_id"
    t.integer  "coffee_box_id"
  end

  create_table "expenses", :force => true do |t|
    t.string   "item"
    t.decimal  "value",         :precision => 5, :scale => 2
    t.date     "date"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.integer  "user_id"
    t.integer  "coffee_box_id"
  end

  create_table "holidays", :force => true do |t|
    t.date     "from"
    t.date     "till"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
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

  create_table "participations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "coffee_box_id"
    t.boolean  "is_active"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "price_of_coffees", :force => true do |t|
    t.decimal  "price",         :precision => 5, :scale => 2
    t.date     "date"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.integer  "coffee_box_id"
  end

  create_table "users", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

end
