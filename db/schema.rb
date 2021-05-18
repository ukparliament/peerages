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
    t.integer  "administration_id"
  end

  create_table "genders", force: :cascade do |t|
    t.string "label",  limit: 10, null: false
    t.string "letter", limit: 1,  null: false
  end

  create_table "jurisdictions", force: :cascade do |t|
    t.string "code",  limit: 10,  null: false
    t.string "label", limit: 100, null: false
  end

  create_table "kingdom_ranks", force: :cascade do |t|
    t.integer "rank_id",    null: false
    t.integer "kingdom_id", null: false
  end

  create_table "kingdoms", force: :cascade do |t|
    t.string "name",     limit: 255, null: false
    t.date   "start_on"
    t.date   "end_on"
  end

  create_table "law_lords", force: :cascade do |t|
    t.integer "old_id",                           null: false
    t.date    "appointed_on",                     null: false
    t.text    "vice"
    t.date    "retired_on"
    t.text    "notes"
    t.text    "jurisdiction_code"
    t.text    "old_office"
    t.date    "annuity_from"
    t.integer "annuity_london_gazette_issue"
    t.integer "annuity_london_gazette_page"
    t.integer "appointment_london_gazette_issue"
    t.integer "appointment_london_gazette_page"
    t.integer "peerage_id"
    t.integer "jurisdiction_id"
  end

  create_table "letters", force: :cascade do |t|
    t.string "letter",  limit: 100, null: false
    t.string "url_key", limit: 1,   null: false
  end

  create_table "letters_patent_times", force: :cascade do |t|
    t.string "time_code", limit: 1,  null: false
    t.string "label",     limit: 20, null: false
  end

  create_table "letters_patents", force: :cascade do |t|
    t.date    "patent_on",                          null: false
    t.string  "patent_time",            limit: 1
    t.string  "previous_title",         limit: 255
    t.string  "previous_rank",          limit: 255
    t.integer "ordinality_on_date"
    t.integer "administration_id"
    t.integer "announcement_id"
    t.integer "letters_patent_time_id"
    t.integer "person_id"
    t.integer "kingdom_id"
  end

  create_table "monarchs", force: :cascade do |t|
    t.string "name", limit: 255, null: false
  end

  create_table "peerage_holdings", force: :cascade do |t|
    t.integer "ordinality",                 null: false
    t.date    "start_on"
    t.date    "end_on"
    t.string  "notes",         limit: 2000
    t.integer "person_id",                  null: false
    t.integer "peerage_id",                 null: false
    t.date    "introduced_on"
  end

  create_table "peerage_types", force: :cascade do |t|
    t.text "code", null: false
    t.text "name"
  end

  create_table "peerages", force: :cascade do |t|
    t.text    "title"
    t.text    "rank_name"
    t.text    "peerage_type_name"
    t.text    "sr"
    t.text    "gender"
    t.text    "territorial_designation"
    t.text    "surname"
    t.text    "previous_title"
    t.text    "previous_rank"
    t.text    "forenames"
    t.date    "date_of_birth"
    t.date    "announced_on"
    t.text    "announcement_type_code"
    t.date    "patent_on"
    t.text    "patent_time"
    t.date    "introduced_on"
    t.date    "date_of_death"
    t.date    "extinct_on"
    t.integer "last_number"
    t.text    "notes"
    t.text    "alpha"
    t.text    "administration_name"
    t.integer "administration_id"
    t.integer "peerage_type_id"
    t.integer "rank_id"
    t.integer "announcement_id"
    t.string  "wikidata_id",             limit: 20
    t.boolean "of_title",                           default: false
    t.integer "special_remainder_id"
    t.integer "letters_patent_id"
    t.integer "kingdom_id"
    t.integer "letter_id"
  end

  create_table "people", force: :cascade do |t|
    t.string  "forenames",     limit: 200, null: false
    t.string  "surname",       limit: 100, null: false
    t.string  "gender_char",   limit: 1,   null: false
    t.date    "date_of_birth"
    t.date    "date_of_death"
    t.integer "letter_id"
    t.integer "gender_id"
    t.string  "wikidata_id",   limit: 20
    t.string  "mnis_id",       limit: 20
    t.string  "rush_id",       limit: 20
  end

  create_table "rank_labels", force: :cascade do |t|
    t.string  "label",     limit: 100, null: false
    t.integer "rank_id",               null: false
    t.integer "gender_id",             null: false
  end

  create_table "ranks", force: :cascade do |t|
    t.text    "code",                                       null: false
    t.text    "name"
    t.integer "degree"
    t.text    "gender_char"
    t.string  "label",           limit: 100
    t.boolean "is_peerage_rank",             default: true
  end

  create_table "special_remainders", force: :cascade do |t|
    t.string "code",        limit: 10,  null: false
    t.string "description", limit: 500, null: false
  end

  create_table "subsidiary_titles", force: :cascade do |t|
    t.text    "title"
    t.text    "rank_code"
    t.text    "subsidiary_title_name"
    t.text    "sr"
    t.text    "territorial_designation"
    t.date    "extinct_on"
    t.integer "last_number"
    t.text    "notes"
    t.text    "alpha"
    t.integer "peerage_id"
    t.date    "patent_on"
    t.text    "patent_time"
    t.integer "rank_id"
    t.boolean "of_title",                default: false
    t.integer "letters_patent_id"
    t.integer "special_remainder_id"
  end

  add_foreign_key "announcements", "announcement_types", name: "announcement_type"
  add_foreign_key "kingdom_ranks", "kingdoms", name: "fk_kingdom"
  add_foreign_key "kingdom_ranks", "ranks", name: "fk_rank"
  add_foreign_key "law_lords", "peerages", name: "peerage"
  add_foreign_key "letters_patents", "administrations", name: "fk_administration"
  add_foreign_key "letters_patents", "announcements", name: "fk_announcement"
  add_foreign_key "letters_patents", "kingdoms", name: "fk_kingdom"
  add_foreign_key "letters_patents", "letters_patent_times", name: "fk_letters_patent_time"
  add_foreign_key "letters_patents", "people", name: "fk_person"
  add_foreign_key "peerage_holdings", "peerages", name: "fk_peerage"
  add_foreign_key "peerage_holdings", "people", name: "fk_person"
  add_foreign_key "peerages", "administrations", name: "administration"
  add_foreign_key "peerages", "announcements", name: "announcement"
  add_foreign_key "peerages", "peerage_types", name: "peerage_type"
  add_foreign_key "peerages", "ranks", name: "rank"
  add_foreign_key "people", "genders", name: "fk_gender"
  add_foreign_key "people", "letters", name: "fk_letter"
  add_foreign_key "rank_labels", "genders", name: "fk_gender"
  add_foreign_key "rank_labels", "ranks", name: "fk_rank"
  add_foreign_key "subsidiary_titles", "peerages", name: "peerage"
  add_foreign_key "subsidiary_titles", "ranks", name: "rank"
end
