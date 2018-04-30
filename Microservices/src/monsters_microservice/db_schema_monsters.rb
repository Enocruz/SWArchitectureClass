# 
# Date: 03-May-2018
# Authors:
#          A01374527 Luis Daniel Rivero Sosa
#          A01374648 Mario Lagunes Nava
#          A01375640 Brandon Alain Cruz Ruiz
# File: db_schema_monsters.rb
# File required to create the database named monsters.db

require 'sequel'

DB = Sequel.connect('sqlite://monsters.db')

DB.drop_table? :monsters

DB.create_table :monsters do
  primary_key   :id
  String        :name
  Integer       :ferocity
  Integer       :room
end