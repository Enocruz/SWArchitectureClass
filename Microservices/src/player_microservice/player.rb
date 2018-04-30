# 
# Date: 03-May-2018
# Authors:
#          A01374527 Luis Daniel Rivero Sosa
#          A01374648 Mario Lagunes Nava
#          A01375640 Brandon Alain Cruz Ruiz
# File: player.rb


require 'sinatra'
require 'json'
require 'sequel'

PORT = 8081
DB = Sequel.connect('sqlite://player.db')
PLAYER_INFO = DB[:player]

# Server configuration
configure do
    set :bind, '0.0.0.0'
    set :port, PORT
end

# Creation of the variables
before do
    content_type :json
    ITEMS = [:sword, :axe, :suit, :light, :amulet, :wealth, :strength, :tally, :monsters_killed, :room, :food, :score, :prev_room]
end

# Error 404
not_found do
    {'error' => "Resource not found #{request.path_info}"}.to_json
end

# Check if the JSON provided has the correct syntax 
def parse_create_player(str)
  begin
    data = JSON.parse(str)
    return data if data['name']
  rescue JSON::ParserError
    # pass
  end
  nil
end

# Check if the player id exists in the DB
def player_exist?(id_player)
  return true if PLAYER_INFO.where(id: id_player).count != 0
  false
end

# Creates a new player
post '/player' do
  data = parse_create_player(request.body.read)
  if data
    id = PLAYER_INFO.insert(
      name: data['name'],
      wealth: 75, 
      strength: 100, 
      tally: 0, 
      food: 0,
      monsters_killed: 0, 
      suit: 0,
      light: 0,
      axe: 0, 
      amulet: 0,
      sword: 0,
      score: 0,
      room: 6,
      time_playing: 0
      )
    [200,{:player_id => "#{id}"}.to_json]
  else
    [400, {'error' => 'Invalid input.'}.to_json]
  end
end

# Get all the players
get '/players' do
  JSON.pretty_generate(
    PLAYER_INFO.order(Sequel.desc(:score), :time_playing).map do |player|
      {
        'name' => player[:name],
        'score' => player[:score],
        'time playing' => player[:time_playing]
      }
    end
  )
end

# Method used to get specific information abouth the items of the player
get '/player/:id/:element' do
  id_player = params['id']
  element = params['element'].to_sym
  if !ITEMS.include?(element)
    [403, {message: "The element: #{element} doesn't exist in the game"}.to_json]
  else
    if player_exist?(id_player)
      JSON.pretty_generate(
        PLAYER_INFO.select(element, :name).where(id: id_player).map do |player|
          {
            'name' => player[:name],
            element => player[element]
          }
        end
      )
    else
      [403, {message: "The player with the id: #{id_player} doesn't exist"}.to_json]
    end
  end
end

# Updates the item information
put '/player' do
  data = JSON.parse(request.body.read)
  id_player = data['id']
  element = data['element'].to_sym
  value = data['value'].to_i
  if ITEMS.include?(element)
    if player_exist?(id_player)
      PLAYER_INFO.where(id: id_player).update(element => value)
      [200, {message: "The element: #{element} is now updated"}.to_json]
    else
      [403, {message: "The player with the id: #{id_player} doesn't exist"}.to_json]
    end
  else
    [403, {message: "The element: #{element} doesn't exist in the game"}.to_json]
  end
end

# Calculates and updates the score
put '/score' do
  data = JSON.parse(request.body.read)
  id_player = data['id']
  if player_exist?(id_player)
    PLAYER_INFO.where(id: id_player).update(:score => 3 * Sequel[:tally] + 5 * Sequel[:strength] + 2 * Sequel[:wealth] + Sequel[:food] + 30 * Sequel[:monsters_killed])
    [200, {message: "The score was calculated"}.to_json]
  else
    [403, {message: "The player with the id: #{id_player} doesn't exist"}.to_json]
  end
end
