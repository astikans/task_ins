# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_05_05_130639) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "applications", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "candidate_name", null: false
    t.jsonb "projection", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_applications_on_job_id"
    t.index ["projection"], name: "index_applications_on_projection", using: :gin
  end

  create_table "events", force: :cascade do |t|
    t.string "type", null: false
    t.string "eventable_type", null: false
    t.bigint "eventable_id", null: false
    t.jsonb "properties", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["eventable_type", "eventable_id"], name: "index_events_on_eventable"
  end

  create_table "jobs", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.jsonb "projection", default: {}, null: false
    t.jsonb "counters", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["projection"], name: "index_jobs_on_projection", using: :gin
  end

  add_foreign_key "applications", "jobs"
end
