# The source code contained in this file is used to
# generate a simple queue.

# Adapter Pattern
# Date: 22-Feb-2018
# Authors:
#          A01374648 Mario Lagunes Nava
#          A01375640 Brandon Alain Cruz Ruiz

# File: simple_queue.rb

# IMPORTANT: Do not modify the following class in any way!

# A class that creates a queue.
class SimpleQueue

  # Initialize the queue.
  def initialize
    @info =[]
  end

  # Inserts x at the back of this queue. Returns this queue.
  def insert(x)
    @info.push(x)
    self
  end

  # Removes and returns the element at the front of this queue. Raises an exception if this queue happens to be empty.
  def remove
    if empty?
      raise "Can't remove if queue is empty"
    else
      @info.shift
    end
  end

  # Returns true if this queue is empty, otherwise returns false.
  def empty?
    @info.empty?
  end

  # Returns the number of elements currently stored in this queue.
  def size
    @info.size
  end

  # Returns the @info in its string form.
  def inspect
    @info.inspect
  end

end