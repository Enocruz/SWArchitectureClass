# The source code contained in this file is used to
# generate tables in different kinds of text formats.

# Observer Pattern
# Date: 26-Jan-2018
# Authors:
#          A01374648 Mario Lagunes Nava 
#          A01375640 Brandon Alain Cruz Ruiz
# File name: twitter.rb

require 'observer'

class Twitter 
	
	# Include the observer class object
	include Observable
	# Create getters and setters for the following variables
	attr_accessor :name
	attr_accessor :message

	# Creates the object with the given parameters
	def initialize(name)
		@name = name
		@message = ''
		# Create empty array for observers
		@observers = []
	end

	# Method to add a follower to the user
	def follow(follower)
		# Add the observer
		follower.add_observer(self)
		self
	end
	
	# Add a tweet message and notify to the followers
	def tweet(tweets)
		@message = tweets
		notify_observers(self)
	end
	
	# Add observer (follower) to the current user
	def add_observer(observer)
		@observers << observer
	end
	
	# Method that is triggered whenever a new tweet is posted
	def notify_observers(user)
		# We print the tweet message for each observer
		@observers.each do |observer|
			puts("#{observer.name} received a tweet from #{user.name}: #{user.message}" + "\n")
		end
	end
end

