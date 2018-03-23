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
  
  def test_get_score
    newGame = Game.new
    assert_equal(650, newGame.get_score)
  end
end