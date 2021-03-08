require 'test/unit'
require_relative '../hotel'

class HotelTest < Test::Unit::TestCase
  setup do
    @num_of_floors = 2
    @per_floor_sub_corridors = 2
    @per_floor_main_corridors = 1
    @hotel = Hotel.new(@num_of_floors, @per_floor_main_corridors, @per_floor_sub_corridors)
  end

  def test_initalize
    floors = @hotel.floors
    floors_count = floors.count
    floor_sub_corridor_count = floors[1]&.sub_corridors&.count
    floor_main_corridor_count = floors[1]&.main_corridors&.count
    assert_equal @num_of_floors, floors_count, 'Hotel initalized number of floors are not as the given argument'
    assert_equal @per_floor_main_corridors, floor_main_corridor_count, 'Hotel initalized per floor main corridors are not as the given argument'
    assert_equal @per_floor_sub_corridors, floor_sub_corridor_count, 'Hotel initalized per floor sub corridors are not as the given argument'
    assert_instance_of Hash, floors
  end

  def test_send_movement_signal
    assert_respond_to(@hotel, :send_movement_signal)
    non_existent_floor_num =  @hotel.floors.size + @hotel.floors.size
    exception = assert_raises(RuntimeError) { @hotel.send_movement_signal(non_existent_floor_num, @per_floor_sub_corridors) }
    assert_equal('No such floor please enter valid floor number', exception.message)
  end

  def test_send_no_movement_signal
    assert_respond_to(@hotel, :send_no_movement_signal)
    non_existent_floor_num =  @hotel.floors.size + @hotel.floors.size
    exception = assert_raises(RuntimeError) { @hotel.send_no_movement_signal(non_existent_floor_num, @per_floor_sub_corridors) }
    assert_equal('No such floor please enter valid floor number', exception.message)
  end
end
