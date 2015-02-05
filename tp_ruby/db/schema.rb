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

ActiveRecord::Schema.define(version: 20150130193153) do

  create_table "attacks", force: :cascade do |t|
    t.integer "id_player"
    t.integer "id_game"
    t.string  "position"
    t.string  "state"
  end

  create_table "games", force: :cascade do |t|
    t.integer "id_creator"
    t.integer "id_opponent"
    t.integer "table"
    t.integer "turn"
    t.integer "players_ready"
  end

  create_table "players", force: :cascade do |t|
    t.string "username"
    t.string "password"
  end

  create_table "ships", force: :cascade do |t|
    t.integer "id_game"
    t.integer "id_player"
    t.string  "position"
    t.integer "attacked"
  end

end
