require 'minitest/autorun'
require 'stringio'
require './main'

class MainTest < Minitest::Test
    
  def with_stdin
    stdin = $stdin             # remember $stdin
    $stdin, write = IO.pipe    # create pipe assigning its "read end" to $stdin
    yield write                # pass pipe's "write end" to block
  ensure
    write.close                # close pipe
    $stdin = stdin             # restore $stdin
  end
  
  # First test
  def test_inventory
    
    # Create all the objets to test
    a = Game.new
    a.inventory
    with_stdin do |user|
      user.puts 3
      assert_equal(View.new.get_inventory_action, 3)
    end
  end

end