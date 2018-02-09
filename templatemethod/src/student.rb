# The source code contained in this file is used to
# test our <em> Template Method Pattern </em>

# Template Method Pattern
# Date: 22-Jan-2018
# Authors:
#          A01374648 Mario Lagunes Nava 
#          A01375640 Brandon Alain Cruz Ruiz
# File name: student.rb

# A class that models the a student from the 
# <em> Tecnológico de Monterrey </em>
class Student

  include Enumerable
  # Note: This class does not support the max, min, 
  # or sort methods.

  # Initialize the variables id, name and grades 
  # according to its parameters.
  def initialize(id, name, grades)
    @id = id
    @name = name
    @grades = grades
  end

  # Prints the id and name of the student.
  def inspect
    "Student(#{@id}, #{@name.inspect})"
  end

  # Sets the average of the student.
  def grade_average
    @grades.inject(:+)/@grades.size
  end

  # This method allow us to send a block of data with different values.
  def each &block
    yield @id
    yield @name
    @grades.each(&block)
    yield grade_average
  end

end