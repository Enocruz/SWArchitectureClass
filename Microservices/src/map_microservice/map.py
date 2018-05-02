# 
# Date: 03-May-2018
# Authors:
#          A01374527 Luis Daniel Rivero Sosa
#          A01374648 Mario Lagunes Nava
#          A01375640 Brandon Alain Cruz Ruiz
# File: map.py

# Map structure
#                         _____________________________
#                         |             |             |
#                     ->        6       |       16     ->
# ________________________|_____  ______|_________  __|  
# |               |       |             |       |     |
# |       2           3          4      |       |     | 
# |______  _______|___  __|_____________|   14  |  15 |
# |               |       |             |             |
# |                       |      7      |       |     |
# |       1       |   5   |             |__  ___|_____|
# |               |       |_____  ______|             |
# |               |_______|             |     13      |
# |______  _______|       |             |_______      |
# |               |   10  |     11      |       |     |  
# |__  __         |                         12        |
# |      |   9     _______|_____________|_______|_____|
# |   8           |
# |______|________|

import sqlite3
import json

from flask import Flask, request, jsonify

app = Flask(__name__)

# Gets the connection to the DB
def connection():
  conn = sqlite3.connect('map.db')
  return conn

# Method used to create a custom response
def create_response(status, message):
  message = {
          'status': status,
          'message': message,
  }
  resp = jsonify(message)
  resp.status_code = status
  return resp

# Not found route
@app.errorhandler(404)
def not_found(error=None):
  return create_response(404, 'Not Found: ' + request.url)
    
# Example call:
# curl localhost:8083/map -X PUT -d '{"room_id": 1, "field":"treasure", "value": 17}' -H "Content-type: application/json"
# GET Method
# Creates a static map
# PUT Method
# Updates the two fields monster or treasure
@app.route('/map', methods=['GET', 'PUT', 'DELETE'])
def game_map():
  conn = connection()
  c = conn.cursor()
  if request.method == 'GET':
    c.execute('''SELECT * FROM map''')
    rooms = c.fetchall()
    if len(rooms) == 0:
      # Id , name, description, left room #, right room #, upside room #, downside room #, monster id #, treasure value
      rooms = [ (1, 'Hall', 'You are in the hall, there is a huge red carpet in the room', 0, 5, 2, 9, 0, 0),
                (2, '', '', 0, 3, 0, 1, 0, 0),
                (3, '', '', 2, 4, 0, 5, 0, 0),
                (4, 'No se', 'Haciendo pruebas canonas jaja', 3, 0, 6, 0, 0, 0),
                (5, '', '', 1, 0, 3, 0, 0, 0),
                (6, 'Entry', 'You are in the entry room, you are facing east', 0, 0, 0, 4, 0, 0),
                (7, '', '', 0, 0, 0, 11, 0, 0),
                (8, '', '', 0, 9, 9, 0, 0, 0),
                (9, '', '', 8, 10, 1, 0, 0, 0),
                (10, '', '', 9, 11, 0, 0, 0, 0),
                (11, '', '', 10, 12, 7, 0, 0, 0),
                (12, '', '', 11, 13, 0, 0, 0, 0),
                (13, '', '', 12, 0, 14, 0, 0, 0),
                (14, '', '', 0, 15, 0, 13, 0, 0),
                (15, '', '', 14, 0, 16, 0, 0, 0),
                (16, 'Exit', 'Congrats!, you made it to the exit', 0, 0, 0, 0, 0, 0)
                ]
      c.executemany('INSERT INTO map VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)', rooms)
      conn.commit()
      conn.close()
      return create_response(200, 'Map created')
    return create_response(500, 'The map already exists')
  elif request.method == 'PUT':
    data = request.get_json()
    id = data['room_id']
    field = data['field']
    value = data['value']
    if field != 'monster' and field != 'treasure':
      return create_response(400, 'Invalid field')
    c.execute('''SELECT * FROM map WHERE id = ? ''', (id, ))
    room = c.fetchone()
    if(room):
      c.execute('''UPDATE map SET {0} = ? where id = ?'''.format(field), (value, id, ))
      count = c.rowcount
      conn.commit()
      conn.close()
      if(count == 1):
        return create_response(200, 'The field {0} for the room with id {1} was updated'.format(field, id))
      return create_response(500, 'There was an error in the DB')
    return create_response(400, 'The room {0} does not exist'.format(id))
  elif request.method == 'DELETE':
    c.execute('''DELETE FROM map''')
    conn.commit()
    conn.close()
    return create_response(200, 'Map eliminated')
    
    
  
# Gets the information for the given room id
@app.route('/map/<int:id>', methods=['GET'])
def get_room(id):
  conn = connection()
  c = conn.cursor()
  c.execute('''SELECT * FROM map WHERE id = ? ''', (id, ))
  room = c.fetchone()
  conn.close()
  if(room):
    return json.dumps({'room_number': room[0],
      'room_name': room[1],
      'room_desc': room[2],
      'left_room_id': room[3],
      'right_room_id': room[4],
      'upside_room_id': room[5],
      'downside_room_id': room[6],
      'monster_id': room[7],
      'treasure_value': room[8]
    }, indent=4, separators=(',', ': ')), 200
  return create_response(400, 'The room {0} does not exist'.format(id))

@app.route('/rooms', methods=['GET'])
def get_rooms():
  conn = connection()
  c = conn.cursor()
  response = {}
  rooms = []
  for room in c.execute('''SELECT * FROM map'''):
    rooms.append(
      {
      'room_number': room[0],
      'room_name': room[1],
      'room_desc': room[2],
      'left_room_id': room[3],
      'right_room_id': room[4],
      'upside_room_id': room[5],
      'downside_room_id': room[6],
      'monster_id': room[7],
      'treasure_value': room[8]
      }
    )
  response['rooms'] = rooms
  return json.dumps(response, indent = 4), 200
  
# Executes the microservice
if __name__ == '__main__':
  app.run(host = "0.0.0.0", port = 8083)