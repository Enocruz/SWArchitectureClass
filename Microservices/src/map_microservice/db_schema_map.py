import sqlite3

def create_connection(db_file):
  conn = sqlite3.connect('map.db')
  c = conn.cursor()
  c.execure('''DROP TABLE IF EXISTS map''')
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
  
  # Save (commit) the changes
  conn.commit()
  
  # We can also close the connection if we are done with it.
  # Just be sure any changes have been committed or they will be lost.
  conn.close()
 
if __name__ == '__main__':
    create_connection("map.db")