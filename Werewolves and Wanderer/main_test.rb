# WEREWOLVES AND WARDERER
# Date: 23-Mar-2018
# Authors:
#          A01374527 Luis Daniel Rivero Sosa
#          A01374648 Mario Lagunes Nava
#          A01375640 Brandon Alain Cruz Ruiz
# File: main_test.rb

require 'minitest/autorun'
require 'stringio'
require './main'

class MainTest < Minitest::Test
  
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
  
  # Method to test the score when starting a new game and when you cheat
  def test_get_score
    newGame = Game.new
    assert_equal(650, newGame.get_score)
    newGame.cheater
    assert_equal(500,newGame.get_score)
  end
  
  # Method to test the process movement with different inputs
  def test_process_movement
    game = Game.new
    puts game.process_movement("S",-1)
    game.process_movement("T", 0)
    game.process_movement("C", 0)
    game.process_movement("F", 0)
    puts ""
    
    assert_equal \
    "FIGHT OR RUN!\n"\
    "false\n"\
    "\n********************************\n"\
    "* YOUR TALLY AT PRESENT IS 650 *\n"\
    "********************************\n"\
    "YOU HAVE NO FOOD\n"\
    "THERE IS NOTHING TO FIGTH HERE\n"\
    "\n",\
    @out.string
  end
  
  def test_pick_up_treasure
    game = Game.new
    game.pick_up_treasure(0)
    
    assert_equal\
    "THERE IS NO TREASURE TO PICK UP\n",\
    @out.string
  end 
end