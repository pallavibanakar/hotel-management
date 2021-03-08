require 'test/unit'
require_relative '../floor'
require_relative '../lib/constants'

class FloorTest < Test::Unit::TestCase
  setup do
    @per_floor_sub_corridors = 2
    @per_floor_main_corridors = 1
    @floor = Floor.new(@per_floor_main_corridors, @per_floor_sub_corridors)
  end

  def test_initalize
    floor_sub_corridor_count = @floor.sub_corridors.count
    floor_main_corridor_count = @floor.main_corridors.count
    assert_equal @per_floor_main_corridors, floor_main_corridor_count, 'Floor initalized per floor main corridors are not according to given argument'
    assert_equal @per_floor_sub_corridors, floor_sub_corridor_count, 'Floor initalized per floor sub corridors are not according to given argument'
    assert_instance_of Hash, @floor.sub_corridors, 'Floor sub_corridors are not instance of hash'
    assert_instance_of Hash, @floor.main_corridors, 'Floor main_corridors are not instance of hash'
  end

  def test_no_movement_sub_corridor
    sub_corridor = @floor.send(:no_movement_sub_corridor)
    assert_equal 0, sub_corridor.light_status, 'Floor no_movement_sub_corridor returned incorrect subcorridor on floor which has light on which indicates there in movement in that particular sub corridor'
  end

  def test_ac_off_corridor
    any_sub_corridor = @floor.sub_corridors.values.first
    any_sub_corridor.switch_off_ac
    sub_corridor = @floor.send(:ac_off_corridor)
    assert_equal any_sub_corridor, sub_corridor, 'Floor ac_off_corridor has returned the subcorridor on floor which has ac on'
  end

  def test_alternate_corridor
    event_corridor_num = 1
    assert_not_same @floor.sub_corridors[event_corridor_num], @floor.send(:alternate_corridor, event_corridor_num), 'Alternate sub corridor returns the same corridor as event corridor'
  end

  def test_movement
    assert_respond_to(@floor, :movement)

    movement_sub_corridor_num = 1
    @floor.movement(movement_sub_corridor_num)
    sub_corridor = @floor.sub_corridors[movement_sub_corridor_num]

    assert_equal 1, sub_corridor.light_status, "On movement trigger of floor's subcorridor the respective subcorridor light is not switched on"
    assert_operator @floor.send(:current_consumption), :<=, @floor.send(:max_consumption), 'Trigger movement has not maintained the less than or equal to max floor consumption'

    non_existent_corridor_num = @per_floor_sub_corridors + @per_floor_sub_corridors
    exception = assert_raises(RuntimeError) { @floor.movement(non_existent_corridor_num) }

    assert_equal('No such corridor please enter valid corridor number', exception.message)
  end

  def test_no_movement
    assert_respond_to(@floor, :no_movement)

    no_movement_sub_corridor_num = 1
    @floor.no_movement(no_movement_sub_corridor_num)
    sub_corridor = @floor.sub_corridors[no_movement_sub_corridor_num]

    assert_equal 0, sub_corridor.light_status, "On no movement trigger of floor's subcorridor the respective subcorridor light has not switched off"
    assert_operator @floor.send(:current_consumption), :<=, @floor.send(:max_consumption), 'Trigger no movement has not maintained less than or equal to max floor consumption'

    non_existent_corridor_num = @per_floor_sub_corridors + @per_floor_sub_corridors
    exception = assert_raises(RuntimeError) { @floor.no_movement(non_existent_corridor_num) }
    assert_equal('No such corridor please enter valid corridor number', exception.message)
  end

  def test_max_consumption
    assert_equal @floor.send(:max_consumption), (@per_floor_sub_corridors * SUB_CORRIDOR_INITIAL_CONSUMPTION + @per_floor_main_corridors * MAIN_CORRIDOR_INITIAL_CONSUMPTION), 'Max consumption is not as per the given formula'
  end

  def test_current_consumption
    initial_consumption = @floor.send(:max_consumption)
    assert_equal @floor.send(:current_consumption), initial_consumption, 'Floor consumption is not equal the addition of each corridor consumption'
  end

  def test_rectify_consumption
    assert_respond_to(@floor, :rectify_consumption)

    (1..@per_floor_sub_corridors).each do |num|
      @floor.sub_corridors[num].switch_on_light
      return if @floor.send(:current_consumption) > @floor.send(:max_consumption)
    end
    @floor.send(:rectify_consumption)

    assert_operator @floor.send(:current_consumption), :<=, @floor.send(:max_consumption), 'Rectify consumption has not maintained less than or equal to max floor consumption'

    (1..@per_floor_sub_corridors).each do |num|
      next if @floor.sub_corridors[num].light_off?
      @floor.sub_corridors[num].switch_on_light
    end
    @floor.send(:rectify_consumption)
    new_floor = Floor.new(@per_floor_main_corridors, @per_floor_sub_corridors)

    assert_operator @floor.send(:current_consumption), :<=, @floor.send(:max_consumption), 'Rectify consumption has not maintained less than or equal to max floor consumption'
    assert_same @floor, new_floor, "Rectify consumption has not brought back floor to initial state when any of the sub corridors don't have movement"
  end
end
