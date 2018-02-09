# The source code contained in this file is used to
# generate tables in different kinds of text formats.

# Template Method Pattern
# Date: 22-Jan-2018
# Authors:
#          A01374648 Mario Lagunes Nava 
#          A01375640 Brandon Alain Cruz Ruiz
# File name: table_generator.rb


# A class that models a table generator.
class TableGenerator

  # Initializes the header and data according to its parameters.
  def initialize(header, data)
    @header = header
    @data = data
  end

  # Generates the table with according to the data attribute.
  def generate
    generate_header_row + (@data.map {|x| generate_row(x)}).join
  end

  # Generates the header of the table according to the header
  # attribute.
  def generate_header_row
    (@header.map {|x| generate_header_item(x)}).join
  end

  # Returns an item of the data.
  def generate_item(item) 
    item
  end

  # Generates a row according to the data.
  def generate_row(row)
    (row.map {|x| generate_item(x)}).join
  end

  # Returns an item of the header.
  def generate_header_item(item)
    item
  end

end

# A class that models a table generator with csv text format.
class CSVTableGenerator < TableGenerator

  # Generates the row using text format csv.
  def generate_row(row)
    "#{(row.map {|x| generate_item(x)}).join(',')}\n"
  end

  # Generates the header of the table calling the method
  # generate_row but with the header attribute.
  def generate_header_row
    generate_row(@header)
  end

end

# A class that models a table generator with html text format.
class HTMLTableGenerator < TableGenerator
  
  # Generates the table according to the header method and the data attributes.
  # Also it includes "</table>" to end the statement of html.
  def generate
    generate_header_row + (@data.map {|x| generate_row(x)}).join + "</table>\n" 
  end

  # Generates the header of the table. Also it includes the tags in order to be an
  # html text format.
  def generate_header_row
    "<table>" + "\n<tr>"+ (@header.map { |x| generate_header_item(x) }).join('</th>') + "</th></tr>" + "\n"
  end
  
  # Return an item acording to the header with the html tag "<th>".
  def generate_header_item(item)
    "<th>#{item}"
  end
  
  # Generates a row according to the data attribute. Also includes the tags in order
  # to be an html text format.
  def generate_row(row)
    "<tr>#{ (row.map {|x| generate_item(x) }).join('</td>') }" + "</td></tr>" + "\n"
  end
  
  # Return an item acording to the data attribute with the html tag <td>
  def generate_item(item)
    "<td>#{item}"
  end
  
end

# A class that models a table generator whit Ascii Doc text format.
class AsciiDocTableGenerator < TableGenerator

  # Generates the table according to the header method and the data attributes.
  # Also it includes the Ascii Doc format.
  def generate
    generate_header_row + (@data.map {|x| generate_row(x)}).join  + "|==========\n"
  end
  
  # Generates the header of the table. Also it includes de Ascii Doc format.
  def generate_header_row
    "[options=\"header\"]" + "\n|==========\n" + "|#{(@header.map { |x| generate_header_item(x) }).join('|')}\n"
  end
  
  # Return an item acording to the header.
  def generate_header_item(item)
    item
  end
  
  # Generates a row according to the data attribute. It is joined with the pipe in 
  # order to make the Ascii Doc format.
  def generate_row(row)
    "|#{ (row.map {|x| generate_item(x) }).join('|') }\n"
  end
  
  # Return an item acording the data.
  def generate_item(item)
    item
  end

end