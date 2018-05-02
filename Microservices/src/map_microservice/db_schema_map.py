import sqlite3

# Creates the DB
def create_connection(db_file):
  conn = sqlite3.connect('map.db')
  c = conn.cursor()
  c.execute('''DROP TABLE IF EXISTS map''')
  # Create table
  c.execute('''CREATE TABLE map
               (id INTEGER PRIMARY KEY, 
               name text,
               description text, 
               left_room int,
               right_room int,
               up_room int,
               down_room int,
               monster int,
               treasure int)''')
  conn.commit()
  conn.close()
 
# Main function
if __name__ == '__main__':
    create_connection("map.db")