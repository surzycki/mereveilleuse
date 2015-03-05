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

ActiveRecord::Schema.define(version: 20150305213002) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "locations", force: :cascade do |t|
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "street"
    t.string   "city"
    t.string   "postal_code"
    t.string   "country"
    t.integer  "locatable_id"
    t.string   "locatable_type"
  end

  add_index "locations", ["locatable_type", "locatable_id"], name: "index_locations_on_locatable_type_and_locatable_id", using: :btree

  create_table "occupations", force: :cascade do |t|
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "experience"
    t.integer  "practitioner_id"
    t.integer  "profession_id"
  end

  add_index "occupations", ["practitioner_id"], name: "index_occupations_on_practitioner_id", using: :btree
  add_index "occupations", ["profession_id"], name: "index_occupations_on_profession_id", using: :btree

  create_table "patient_types", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  create_table "patient_types_recommendations", id: false, force: :cascade do |t|
    t.integer "patient_type_id"
    t.integer "recommendation_id"
  end

  add_index "patient_types_recommendations", ["patient_type_id"], name: "index_patient_types_recommendations_on_patient_type_id", using: :btree
  add_index "patient_types_recommendations", ["recommendation_id"], name: "index_patient_types_recommendations_on_recommendation_id", using: :btree

  create_table "practitioners", force: :cascade do |t|
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.string   "phone"
    t.string   "mobile_phone"
  end

  create_table "professions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  create_table "recommendations", force: :cascade do |t|
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "wait_time"
    t.integer  "availability"
    t.integer  "bedside_manner"
    t.integer  "efficacy"
    t.text     "comment"
    t.integer  "user_id"
    t.integer  "practitioner_id"
  end

  add_index "recommendations", ["practitioner_id"], name: "index_recommendations_on_practitioner_id", using: :btree
  add_index "recommendations", ["user_id"], name: "index_recommendations_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "facebook_id"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.boolean  "has_invited"
  end

end
