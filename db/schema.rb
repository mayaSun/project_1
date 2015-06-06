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

ActiveRecord::Schema.define(version: 20150318131155) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: true do |t|
    t.string "name"
    t.text   "description"
    t.string "slug"
  end

  create_table "orders", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "city"
    t.string   "country_code"
    t.string   "state_code"
    t.string   "postal_code"
    t.string   "phone_number"
    t.string   "email"
    t.string   "status"
    t.integer  "user_id"
    t.string   "reference_id"
    t.string   "confirmation_number"
    t.string   "tracking_number"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_symbols", force: true do |t|
    t.integer "product_id"
    t.integer "sacred_symbol_id"
  end

  create_table "products", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "price"
    t.integer  "stock"
    t.integer  "category_id"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  create_table "sacred_symbols", force: true do |t|
    t.string "name"
    t.string "image"
    t.text   "description"
    t.string "slug"
  end

  create_table "user_shopping_bag_items", force: true do |t|
    t.integer  "product_id"
    t.integer  "position_id"
    t.string   "position_type"
    t.integer  "qty"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_shopping_bag_items", ["position_id", "position_type"], name: "index_user_shopping_bag_items_on_position_id_and_position_type", using: :btree

  create_table "user_wishlist_items", force: true do |t|
    t.integer  "product_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "role",            default: "customer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

end
