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

ActiveRecord::Schema.define(version: 20141110210033) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: true do |t|
    t.integer  "home_goals"
    t.integer  "away_goals"
    t.integer  "day"
    t.integer  "home_team_id"
    t.integer  "away_team_id"
    t.integer  "tournament_id"
    t.integer  "season_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "games", ["away_team_id"], name: "index_games_on_away_team_id", using: :btree
  add_index "games", ["home_team_id"], name: "index_games_on_home_team_id", using: :btree
  add_index "games", ["season_id"], name: "index_games_on_season_id", using: :btree
  add_index "games", ["tournament_id"], name: "index_games_on_tournament_id", using: :btree

  create_table "ranking3pts", force: true do |t|
    t.integer  "season_id"
    t.integer  "day"
    t.integer  "team_id"
    t.integer  "points"
    t.integer  "wins"
    t.integer  "draws"
    t.integer  "losts"
    t.integer  "goals_for"
    t.integer  "goals_against"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rank"
    t.integer  "goals_diff"
    t.integer  "days"
  end

  add_index "ranking3pts", ["season_id"], name: "index_ranking3pts_on_season_id", using: :btree
  add_index "ranking3pts", ["team_id"], name: "index_ranking3pts_on_team_id", using: :btree

  create_table "seasons", force: true do |t|
    t.integer  "start"
    t.integer  "end"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tournaments", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
