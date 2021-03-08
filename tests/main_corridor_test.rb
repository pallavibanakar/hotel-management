require 'test/unit'
require_relative '../main_corridor'

class MainCorridorTest < Test::Unit::TestCase
  setup do
    @main_corridor = MainCorridor.new
  end

  def test_initialize
    assert_equal 1, @main_corridor.light_status, 'Main corridor object is initalized with light status off'
    assert_equal 1, @main_corridor.ac_status, 'Main corridor object is initalized with ac status off'
  end
end
