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

ActiveRecord::Schema.define(version: 20150327025255) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "federations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  create_table "federations_practitioners", id: false, force: :cascade do |t|
    t.integer "federation_id"
    t.integer "practitioner_id"
  end

  add_index "federations_practitioners", ["federation_id"], name: "index_federations_practitioners_on_federation_id", using: :btree
  add_index "federations_practitioners", ["practitioner_id"], name: "index_federations_practitioners_on_practitioner_id", using: :btree

  create_table "help_topics", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  create_table "insurances", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  create_table "insurances_practitioners", id: false, force: :cascade do |t|
    t.integer "insurance_id"
    t.integer "practitioner_id"
  end

  add_index "insurances_practitioners", ["insurance_id"], name: "index_insurances_practitioners_on_insurance_id", using: :btree
  add_index "insurances_practitioners", ["practitioner_id"], name: "index_insurances_practitioners_on_practitioner_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "street"
    t.string   "city"
    t.string   "postal_code"
    t.string   "country"
    t.integer  "locatable_id"
    t.string   "locatable_type"
    t.float    "latitude",         default: 0.0
    t.float    "longitude",        default: 0.0
    t.string   "department"
    t.string   "region"
    t.string   "unparsed_address"
    t.integer  "status",           default: 0
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
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.string   "phone"
    t.string   "mobile_phone"
    t.string   "uuid"
    t.integer  "status",       default: 0
  end

  create_table "professions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  create_table "recommendations", force: :cascade do |t|
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "wait_time"
    t.integer  "availability"
    t.integer  "bedside_manner"
    t.integer  "efficacy"
    t.text     "comment"
    t.integer  "user_id"
    t.integer  "practitioner_id"
    t.string   "state",           default: "step_one"
    t.integer  "profession_id"
  end

  add_index "recommendations", ["practitioner_id"], name: "index_recommendations_on_practitioner_id", using: :btree
  add_index "recommendations", ["profession_id"], name: "index_recommendations_on_profession_id", using: :btree
  add_index "recommendations", ["user_id"], name: "index_recommendations_on_user_id", using: :btree

  create_table "searches", force: :cascade do |t|
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "status",      default: 0
    t.text     "information"
    t.integer  "user_id"
    t.text     "settings"
    t.string   "md5_hash"
  end

  add_index "searches", ["user_id"], name: "index_searches_on_user_id", using: :btree

  create_table "searches_patient_types", id: false, force: :cascade do |t|
    t.integer "search_id"
    t.integer "patient_type_id"
  end

  add_index "searches_patient_types", ["patient_type_id"], name: "index_searches_patient_types_on_patient_type_id", using: :btree
  add_index "searches_patient_types", ["search_id"], name: "index_searches_patient_types_on_search_id", using: :btree

  create_table "searches_professions", id: false, force: :cascade do |t|
    t.integer "search_id"
    t.integer "profession_id"
  end

  add_index "searches_professions", ["profession_id"], name: "index_searches_professions_on_profession_id", using: :btree
  add_index "searches_professions", ["search_id"], name: "index_searches_professions_on_search_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "facebook_id"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.boolean  "has_invited",   default: false
    t.integer  "status",        default: 0
    t.string   "profile_image"
  end

end
