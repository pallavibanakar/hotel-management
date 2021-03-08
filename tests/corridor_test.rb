require 'test/unit'
require_relative '../corridor'
require_relative '../lib/constants'

class CorridorTest < Test::Unit::TestCase
  setup do
    @corridor = Corridor.new({ light_status: 0, ac_status: 0 })
  end

  def test_initalize
    assert_equal @corridor.light_status, Corridor.new({ light_status: 0, ac_status: 0 }).light_status, 'A corridor object is not initalized with given light status'
    assert_equal @corridor.ac_status, Corridor.new({ light_status: 0, ac_status: 0 }).ac_status, 'A corridor object is not initalized with given ac status'
  end

  def test_switch_on_light
    assert_respond_to(@corridor, :switch_on_light)
    light_status = @corridor.switch_on_light
    assert_equal 1, light_status, 'Switched on light has changed the light status to 0'
    assert_equal @corridor.light_status, light_status, 'Switched on light has changed the light status to off'
  end

  def test_switch_off_light
    assert_respond_to(@corridor, :switch_off_light)
    light_status = @corridor.switch_off_light
    assert_equal 0, light_status, 'Switched off light has changed the light status to 1'
    assert_equal @corridor.light_status, light_status, 'Switched off light changed the light status to on'
  end

  def test_switch_on_ac
    assert_respond_to(@corridor, :switch_on_ac)
    ac_status = @corridor.switch_on_ac
    assert_equal 1, ac_status, 'Switched on AC has changed the AC status to 0'
    assert_equal @corridor.ac_status, ac_status, 'Switched on AC has changed the AC status to off'
  end

  def test_switch_off_ac
    assert_respond_to(@corridor, :switch_off_ac)
    ac_status = @corridor.switch_off_ac
    assert_equal 0, ac_status, 'Switched off AC has changed the AC status to 1'
    assert_equal @corridor.ac_status, ac_status, 'Switched off AC changed the AC status to on'
  end

  def test_ac_on?
    assert_respond_to(@corridor, :ac_on?)
    @corridor.switch_on_ac
    assert @corridor.ac_on?, "AC on gave a wrong status"
    @corridor.switch_off_ac
    assert_equal false, @corridor.ac_on?, "AC on returned true for corridor whose AC is off"
  end

  def test_ac_off?
    assert_respond_to(@corridor, :ac_off?)
    @corridor.switch_off_ac
    assert @corridor.ac_off?, "AC off gave a wrong status"
    @corridor.switch_on_ac
    assert_equal false, @corridor.ac_off?, "AC off returned true for corridor whose AC is on"
  end

  def test_light_on?
    assert_respond_to(@corridor, :light_on?)
    @corridor.switch_on_light
    assert @corridor.light_on?, "Light on gave a wrong status"
    @corridor.switch_off_light
    assert_equal false, @corridor.light_on?, "Light on returned true for corridor whose light is off"
  end

  def test_light_off?
    assert_respond_to(@corridor, :light_off?)
    @corridor.switch_off_light
    assert @corridor.light_off?, "Light off gave a wrong status"
    @corridor.switch_on_light
    assert_equal false, @corridor.light_off?, "Light off returned true for corridor whose Light is on"
  end

  def test_consumption
    assert_respond_to(@corridor, :consumption)
    assert_equal (@corridor.light_status * LIGHT_CONSUMPTION + @corridor.ac_status * AC_CONSUMPTION), @corridor.consumption, 'Corridor consumption gives has not given the total consumption of light and ac according to thier status'
  end
end
