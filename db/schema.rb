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

ActiveRecord::Schema.define(version: 2020_07_21_111511) do

  create_table "event_store_events", id: :string, limit: 36, force: :cascade do |t|
    t.string "event_type", null: false
    t.binary "metadata"
    t.binary "data", null: false
    t.datetime "created_at", null: false
    t.index ["created_at"], name: "index_event_store_events_on_created_at"
    t.index ["event_type"], name: "index_event_store_events_on_event_type"
  end

  create_table "event_store_events_in_streams", force: :cascade do |t|
    t.string "stream", null: false
    t.integer "position"
    t.string "event_id", limit: 36, null: false
    t.datetime "created_at", null: false
    t.index ["created_at"], name: "index_event_store_events_in_streams_on_created_at"
    t.index ["stream", "event_id"], name: "index_event_store_events_in_streams_on_stream_and_event_id", unique: true
    t.index ["stream", "position"], name: "index_event_store_events_in_streams_on_stream_and_position", unique: true
  end

  create_table "inventory_controls_product_stocks", force: :cascade do |t|
    t.string "product_id"
    t.integer "quantity", default: 0
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.string "address"
  end

  create_table "orders", force: :cascade do |t|
    t.string "uid"
    t.string "product_id"
    t.integer "quantity"
    t.string "state"
  end

  create_table "products", force: :cascade do |t|
    t.string "uid"
    t.string "state"
    t.string "name"
  end

  create_table "stocks", force: :cascade do |t|
    t.string "product_id"
    t.integer "quantity"
    t.integer "location_id"
    t.string "product_name"
    t.string "location_name"
    t.string "location_address"
  end

end
