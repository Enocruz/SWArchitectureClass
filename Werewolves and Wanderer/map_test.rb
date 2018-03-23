# WEREWOLVES AND WARDERER
# Date: 23-Mar-2018
# Authors:
#          A01374527 Luis Daniel Rivero Sosa
#          A01374648 Mario Lagunes Nava
#          A01375640 Brandon Alain Cruz Ruiz
# File: map_test.rb

require 'minitest/autorun'
require 'stringio'
require './map'

# Class declaration
class TwitterTest < Minitest::Test
  # Set up all the variables for the tests
  def setup
    @out = StringIO.new
    @old_stdout = $stdout
    $stdout = @out
  end
  
  # Called after every test method runs
  def teardown
    $stdout = @old_stdout
  end

  # First test
  def test_twitter_alices_adventures_in_wonderland
    
    # Create all the objets to test
    mapa = Map.new
    puts mapa.currentRoom
    puts mapa.move("E")
    puts mapa.currentRoom
    puts mapa.move("N")
    puts mapa.getMoveError("N")
    puts mapa.move("S")
    puts mapa.currentRoom
    puts mapa.move("S")
    puts mapa.currentRoom
    puts mapa.move("E")
    puts mapa.currentRoom
    mapa.setEmptyRoom
    puts mapa.move("N")
    puts mapa.currentRoom
    puts mapa.isPossibleMove("D")
    puts mapa.getMoveError("U")
    puts mapa.move("S")
    puts mapa.getTreasuresAndMonsters
    puts mapa.currentRoom
    puts mapa.getMoveError("E")
    puts mapa.move("U")
    puts mapa.currentRoom
    puts mapa.isPossibleMove("W")
    puts mapa.getMoveError("W")
    puts mapa.getMoveError("S")
    puts mapa.move("N")
    puts mapa.currentRoom
    puts mapa.getMoveError("D")
    puts mapa.previousRoom
    puts mapa.getRoomDescription
    puts mapa.move("E")
    puts mapa.currentRoom
    puts mapa.move("S")
    puts mapa.currentRoom
    puts mapa.move("E")
    puts mapa.currentRoom
    puts mapa.move("N")
    puts mapa.currentRoom
    puts mapa.move("D")
    puts mapa.currentRoom
    puts mapa.move("S")
    puts mapa.currentRoom
    puts mapa.isGameWon
    puts mapa.move("E")
    puts mapa.currentRoom
    puts mapa.isGameWon
    
    
    puts ""

    # Begin tests
    assert_equal \
      "6\n"\
      "true\n"\
      "1\n"\
      "false\n"\
      "NO EXIT THAT WAY\n"\
      "true\n"\
      "2\n"\
      "true\n"\
      "3\n"\
      "true\n"\
      "5\n"\
      "true\n"\
      "4\n"\
      "false\n"\
      "THERE IS NO WAY UP FROM HERE\n"\
      "true\n"\
      "0\n"\
      "5\n"\
      "YOU CANNOT GO IN THAT DIRECTION\n"\
      "true\n"\
      "15\n"\
      "false\n"\
      "YOU CANNOT MOVE THROUGH SOLID STONE\n"\
      "THERE IS NO EXIT SOUTH\n"\
      "true\n"\
      "14\n"\
      "YOU CANNOT DESCEND FROM HERE\n"\
      "15\n"\
      "YOU ARE IN THE MASTER BEDROOM ON THE UPPER LEVEL OF THE CASTLE....
LOOKING DOWN FROM THE WINDOW TO THE WEST YOU CAN SEE THE ENTRANCE TO THE
CASTLE, WHILE THE SECRET HERB GARDEN IS VISIBLE BELOW THE NORTH WINDOW.
THERE ARE DOORS TO THE EAST AND TO THE SOUTH....\n"\
      "true\n"\
      "17\n"\
      "true\n"\
      "16\n"\
      "true\n"\
      "19\n"\
      "true\n"\
      "9\n"\
      "true\n"\
      "8\n"\
      "true\n"\
      "10\n"\
      "false\n"\
      "true\n"\
      "11\n"\
      "true\n"\
      "\n",\
      @out.string
  end
end