# 
# Date: 03-May-2018
# Authors:
#          A01374527 Luis Daniel Rivero Sosa
#          A01374648 Mario Lagunes Nava
#          A01375640 Brandon Alain Cruz Ruiz
# File: db_schema_monsters.rb
# File required to create the database named monsters.db

# The source code contained in this file define the monsters
#microservice database and it connection

require 'sequel'

#Final variable that save the connection to database
DB = Sequel.connect('sqlite://monsters.db')

#Eliminate the table of monsters if it exist
DB.drop_table? :monsters

#Create the monster table
DB.create_table :monsters do
  primary_key   :id
  Integer       :identifier
  String        :name
  Integer       :ferocity
  Integer       :room
end