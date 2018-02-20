# Adapter Pattern
# Date: 22-Feb-2018
# Authors:
#          A01374648 Mario Lagunes Nava
#          A01375640 Brandon Alain Cruz Ruiz

# File: queue_adapter.rb

class QueueAdapter

	def initialize(q)
		@adaptee = q
	end

	def push(x)
		@adaptee.(x)
		self
	end

	def pop
		return nil if @adaptee.empty?
		@adaptee.peek
		@adaptee.remove
	end

	def peek
		begin 
			@adaptee.peek
		rescue StopIteration
			nil
	end

	def empty?
		@adaptee.empty?
	end

	def size
		@adaptee.size
	end

	def insert(x)
    @info.push(x)
    self
  end

  def remove
    if empty?
      raise "Can't remove if queue is empty"
    else
      @info.shift
    end
  end

  def empty?
    @info.empty?
  end

  def size
    @info.size
  end

  def inspect
    @info.inspect
  end


end

push(x)	Inserts x at the top of this stack. Returns this stack.
