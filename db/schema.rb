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

ActiveRecord::Schema.define(version: 20150112212711) do

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

  create_table "sqw_games", force: true do |t|
    t.datetime "kickoff"
    t.string   "venue"
    t.integer  "home_goals"
    t.integer  "away_goals"
    t.integer  "sqw_home_team_id"
    t.integer  "sqw_away_team_id"
    t.integer  "sqw_season_id"
    t.integer  "sqw_tournament_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sqw_games", ["sqw_away_team_id"], name: "index_sqw_games_on_sqw_away_team_id", using: :btree
  add_index "sqw_games", ["sqw_home_team_id"], name: "index_sqw_games_on_sqw_home_team_id", using: :btree
  add_index "sqw_games", ["sqw_season_id"], name: "index_sqw_games_on_sqw_season_id", using: :btree
  add_index "sqw_games", ["sqw_tournament_id"], name: "index_sqw_games_on_sqw_tournament_id", using: :btree

  create_table "sqw_player_games", force: true do |t|
    t.integer  "sqw_game_id"
    t.integer  "sqw_player_id"
    t.integer  "weight"
    t.integer  "height"
    t.string   "shirt_num"
    t.float    "total_influence"
    t.integer  "x_loc"
    t.integer  "y_loc"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "position"
  end

  add_index "sqw_player_games", ["sqw_game_id"], name: "index_sqw_player_games_on_sqw_game_id", using: :btree
  add_index "sqw_player_games", ["sqw_player_id"], name: "index_sqw_player_games_on_sqw_player_id", using: :btree

  create_table "sqw_players", force: true do |t|
    t.integer  "sqw_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "name"
    t.string   "surname"
    t.string   "photo"
    t.date     "dob"
    t.string   "country"
    t.integer  "sqw_team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sqw_players", ["sqw_team_id"], name: "index_sqw_players_on_sqw_team_id", using: :btree

  create_table "sqw_seasons", force: true do |t|
    t.integer  "start"
    t.integer  "end"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sqw_teams", force: true do |t|
    t.integer  "sqw_id"
    t.string   "long_name"
    t.string   "short_name"
    t.string   "logo"
    t.string   "shirt_url"
    t.string   "club_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "team_color"
  end

  create_table "sqw_tournaments", force: true do |t|
    t.string   "name"
    t.string   "country"
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
