# The source code contained in this file is used to
# generate a queue adapter.

# Adapter Pattern
# Date: 22-Feb-2018
# Authors:
#          A01374648 Mario Lagunes Nava
#          A01375640 Brandon Alain Cruz Ruiz

# File: queue_adapter.rb

# A class that adapts the simpleQueue class and implements some methods.
class QueueAdapter

	# Initializes a new stack, using q as the adaptee and the auxiliary array.
	def initialize(q)
		@adaptee = q
		@auxiliar = []
	end

	# Inserts x at the top of this stack. Returns this stack.
	def push(x)
		if(@adaptee.size == 0)
			@adaptee.insert(x)
			@auxiliar.unshift(x)
		else
			@auxiliar.each{|a| @adaptee.remove}
			@auxiliar.unshift(x)
			@auxiliar.each{|a| @adaptee.insert(a)}
		end
		self
	end

	# Returns nil if this stack is empty, otherwise removes and returns its top element.
	def pop
		return nil if @adaptee.empty?
		@adaptee.remove
		@auxiliar.first
		@auxiliar.shift
	end

	# Returns nil if this stack is empty, otherwise returns its top element without removing it.
	def peek
		return nil if @adaptee.empty?
		@auxiliar.first
	end

	# Returns true if this stack is empty, otherwise returns false.
	def empty?
		@adaptee.empty?
	end

	# Returns the number of elements currently stored in this stack.
	def size
		@adaptee.size
	end

end