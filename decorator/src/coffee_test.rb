# The source code contained in this file is used to
# test the coffee.rb program.

# Adapter Pattern
# Date: 08-March-2018
# Authors:
#          A01374648 Mario Lagunes Nava
#          A01375640 Brandon Alain Cruz Ruiz

# File: coffee_test.rb


# Adding the namespaces require to run the file
require 'minitest/autorun'
require './coffee'

# Class declaration
class CoffeeTest < Minitest::Test
    # Testing the Espresso class with no condiments
    def test_espresso
        beverage = Espresso.new
        assert_equal("Espresso", beverage.description)
        assert_equal(1.99, beverage.cost)
    end
    # Testing the DarkRoast class with condiments
    def test_dark_roast
        beverage = DarkRoast.new
        beverage = Milk.new(beverage)
        beverage = Mocha.new(beverage)
        beverage = Mocha.new(beverage)
        beverage = Whip.new(beverage)
        assert_equal("Dark Roast Coffee, Milk, Mocha, Mocha, Whip", 
                     beverage.description)
        assert_equal(1.59, beverage.cost)
    end
    # Testing the HouseBlend class with condiments
    def test_house_blend
        beverage = HouseBlend.new
        beverage = Soy.new(beverage)
        beverage = Mocha.new(beverage)
        beverage = Whip.new(beverage)
        assert_equal("House Blend Coffee, Soy, Mocha, Whip", 
                     beverage.description)
        assert_equal(1.34, beverage.cost)
    end

end