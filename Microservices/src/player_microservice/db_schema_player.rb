# 
# Date: 03-May-2018
# Authors:
#          A01374527 Luis Daniel Rivero Sosa
#          A01374648 Mario Lagunes Nava
#          A01375640 Brandon Alain Cruz Ruiz
# File: db_schema_player.rb
# File required to create the database named player.db

require 'sequel'

DB = Sequel.connect('sqlite://player.db')

DB.drop_table? :player

DB.create_table :player do
  primary_key   :id
  String        :name
  Integer       :food
  Integer       :wealth
  Integer       :strength
  Integer       :tally
  Integer       :monsters_killed
  Integer       :suit
  Integer       :light
  Integer       :axe
  Integer       :amulet
  Integer       :sword
  Integer       :score
  Integer       :room
  Integer       :prev_room
  Integer       :game_completed
  Float         :time_playing
end