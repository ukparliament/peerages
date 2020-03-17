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

ActiveRecord::Schema.define(version: 0) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "administrations", force: :cascade do |t|
    t.integer "number"
    t.text    "prime_minister", null: false
    t.date    "start_date"
    t.date    "end_date"
    t.text    "colour_code"
  end

  create_table "announcement_types", force: :cascade do |t|
    t.text "code", null: false
    t.text "name"
  end

  create_table "announcements", force: :cascade do |t|
    t.date     "announced_on",             null: false
    t.text     "announcement_type_code",   null: false
    t.boolean  "in_gazette"
    t.integer  "gazette_issue_number"
    t.datetime "gazette_publication_date"
    t.text     "gazette_page_number"
    t.integer  "number"
    t.text     "notes"
    t.integer  "announcement_type_id"
  end

  create_table "law_lords", force: :cascade do |t|
    t.integer "old_id",                           null: false
    t.date    "appointed_on",                     null: false
    t.text    "vice"
    t.date    "retired_on"
    t.text    "notes"
    t.text    "jurisdiction"
    t.text    "old_office"
    t.date    "annuity_from"
    t.integer "annuity_london_gazette_issue"
    t.integer "annuity_london_gazette_page"
    t.integer "appointment_london_gazette_issue"
    t.integer "appointment_london_gazette_page"
    t.integer "peerage_id"
  end

  create_table "peerage_types", force: :cascade do |t|
    t.text "code", null: false
    t.text "name"
  end

  create_table "peerages", force: :cascade do |t|
    t.text     "title"
    t.text     "rank_name"
    t.text     "peerage_type_name"
    t.text     "sr"
    t.text     "gender"
    t.text     "of"
    t.text     "surname"
    t.text     "previous_title"
    t.text     "previous_rank"
    t.text     "forenames"
    t.date     "date_of_birth"
    t.date     "announced_on"
    t.text     "announcement_type_code"
    t.date     "patent"
    t.text     "time"
    t.datetime "introduction"
    t.date     "date_of_death"
    t.datetime "extinct"
    t.integer  "last_number"
    t.text     "notes"
    t.text     "alpha"
    t.text     "administration_name"
    t.integer  "administration_id"
    t.integer  "peerage_type_id"
    t.integer  "rank_id"
    t.integer  "announcement_id"
  end

  create_table "ranks", force: :cascade do |t|
    t.text    "code",                 null: false
    t.text    "name"
    t.integer "degree"
    t.text    "gender"
    t.integer "announcement_type_id"
  end

  create_table "subsidiary_titles", force: :cascade do |t|
    t.text     "title"
    t.text     "rank"
    t.text     "subsidary_title_name"
    t.text     "sr"
    t.text     "of"
    t.datetime "extinct"
    t.integer  "last_number"
    t.text     "notes"
    t.text     "alpha"
    t.integer  "peerage_id"
    t.datetime "patent"
    t.text     "time"
    t.text     "Surname"
  end

  add_foreign_key "law_lords", "peerages", name: "peerage"
  add_foreign_key "peerages", "administrations", name: "administration"
  add_foreign_key "peerages", "announcements", name: "announcement"
  add_foreign_key "peerages", "peerage_types", name: "peerage_type"
  add_foreign_key "peerages", "ranks", name: "rank"
  add_foreign_key "subsidiary_titles", "peerages", name: "peerage"
end
