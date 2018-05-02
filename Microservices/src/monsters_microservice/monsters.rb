# 
# Date: 03-May-2018
# Authors:
#          A01374527 Luis Daniel Rivero Sosa
#          A01374648 Mario Lagunes Nava
#          A01375640 Brandon Alain Cruz Ruiz
# File: monsters.rb


require 'sinatra'
require 'json'
require 'sequel'

PORT = 8082
DB = Sequel.connect('sqlite://monsters.db')
MONSTERS = DB[:monsters]

# Server configuration
configure do
    set :bind, '0.0.0.0'
    set :port, PORT
end

# Creation of the variables
before do
    content_type :json
end

# Error 404
not_found do
    {'error' => "Resource not found #{request.path_info}"}.to_json
end

# Check wether the monster exist in the DB or not
def monster_exist?(id_monster)
  return true if MONSTERS.where(id: id_monster).count != 0
  false
end

# Check if the JSON provided has the correct syntax 
def parse_create_monster(str)
  begin
    data = JSON.parse(str)
    return data if data['name'] && data['ferocity']
  rescue JSON::ParserError
    # pass
  end
  nil
end

# Create a new monster
post '/monster' do
  data = parse_create_monster(request.body.read)
  if data
    @id = MONSTERS.insert(
      name: data['name'],
      ferocity: data['ferocity'],
      room: data['room']
      )
    [200,{:monster_id => "#{@id}"}.to_json]
  else
    [400, {'error' => 'Invalid input.'}.to_json]
  end
end

# Get the monsters for the given id
get '/monster/:id' do
  id_monster = params['id']
  if(monster_exist?(id_monster))
    JSON.pretty_generate(
      MONSTERS.where(id: id_monster).map do |monster|
        {
          'name' => monster[:name],
          'ferocity' => monster[:ferocity],
          'room' => monster[:room]
        }
      end
    )
  else
    [403, {message: "The monster with the id: #{id_monster} doesn't exist"}.to_json]
  end
end

# Delete the monster when the player defeat it
delete '/monster/:id' do
  id_monster = params['id']
  if(monster_exist?(id_monster))
    count = MONSTERS.where(id: id_monster).delete
    if(count != 0)
      [403, {message: "There was a problem trying to delete"}.to_json]
    end
    [200, {message: "The monster with the id: #{id_monster} was eliminated"}.to_json]
  else
    [403, {message: "The monster with the id: #{id_monster} doesn't exist"}.to_json]
  end
end

delete '/monsters' do
  MONSTERS.truncate
  [200, {message: "All monsters were deleted"}.to_json]
end

# Updates the ferocity
put '/monster/:id' do
  id_monster = params['id']
  data = JSON.parse(request.body.read)
  ferocity = data['ferocity']
  if(monster_exist?(id_monster))
    MONSTERS.where(id: id_monster).update(:ferocity => ferocity)
    [200, {message: "Ferocity updated"}.to_json]
  else
    [403, {message: "The monster with the id: #{id_monster} doesn't exist"}.to_json]
  end
end