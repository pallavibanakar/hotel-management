require 'test/unit'
require_relative '../sub_corridor'

class SubCorridorTest < Test::Unit::TestCase
  setup do
    @sub_corridor = SubCorridor.new
  end

  def test_initialize
    assert_equal 0, @sub_corridor.light_status, 'Sub corridor object is initalized with light status on'
    assert_equal 1, @sub_corridor.ac_status, 'Sub corridor object is initalized with ac status off'
  end

  def test_trigger_movement
    assert_respond_to(@sub_corridor, :trigger_movement)

    @sub_corridor.trigger_movement

    assert_equal 1, @sub_corridor.light_status, "On movement trigger of subcorridor the respective subcorridor light is still switch off"
    assert_equal 1, @sub_corridor.ac_status, "On movement trigger of subcorridor the respective subcorridor ac is switched off"
  end

  def test_trigger_no_movement
    assert_respond_to(@sub_corridor, :trigger_no_movement)
    ac_status = @sub_corridor.ac_status
    @sub_corridor.trigger_no_movement

    assert_equal 0, @sub_corridor.light_status, "On no movement trigger of floor's subcorridor the respective subcorridor light is still on"
    assert_equal 1, @sub_corridor.ac_status, "On no movement trigger of floor's subcorridor the respective subcorridor ac is off"
    assert_same ac_status, @sub_corridor.ac_status, "On no movement trigger of floor's subcorridor the respective subcorridor ac status has changed"
  end
end
