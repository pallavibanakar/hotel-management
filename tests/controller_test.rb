require 'test/unit'
require_relative '../controller'

class ControllerTest < Test::Unit::TestCase
	setup do
    @num_of_floors = 2
    @per_floor_sub_corridors = 2
    @per_floor_main_corridors = 1
		@controller = Controller.new(@num_of_floors, @per_floor_main_corridors,  @per_floor_sub_corridors)
  end

	def test_movement
		assert_respond_to(@controller, :movement)
		event_floor_num = 1
		event_sub_corridor_num = 2
		floor = @controller.hotel.floors[event_floor_num]
		sub_corridor = floor.sub_corridors[event_sub_corridor_num]
    non_movement_sub_corridor = floor.sub_corridors[1]
    non_movement_floor = @controller.hotel.floors[2]

		@controller.movement(event_floor_num, event_sub_corridor_num)


    assert_equal 1, sub_corridor.light_status, 'Movement Sub corridor light has not been turned on'
    assert_equal 1, sub_corridor.ac_status, 'Movement Sub corridor AC has not been turned on'
    assert_equal 0, non_movement_sub_corridor.light_status, 'Non movement Sub corridor has light status on'
    assert_equal 0, non_movement_sub_corridor.ac_status, 'Non movement Sub corridor has ac status on and not matained floor consumption'
    assert_same non_movement_floor, @controller.hotel.floors[2], 'Non movement floor status has been changed'
    assert_operator floor.send(:current_consumption), :<=, floor.send(:max_consumption), 'Floor consumption is not maintained'
	end

	def test_no_movement
		assert_respond_to(@controller, :no_movement)

		event_floor_num = 1
		event_sub_corridor_num = 2
		duration = 0
		floor = @controller.hotel.floors[event_floor_num]
		sub_corridor = floor.sub_corridors[event_sub_corridor_num]
    non_event_sub_corridor = floor.sub_corridors[1]
    non_movement_floor = @controller.hotel.floors[2]
    @controller.movement(event_floor_num, event_sub_corridor_num)
		@controller.no_movement(event_floor_num, event_sub_corridor_num, duration)


    assert_equal 1, sub_corridor.light_status, 'No movement event Sub corridor light status has been changed with duration less than 1 min'
    assert_equal 1, sub_corridor.ac_status, 'No movement event Sub corridor AC status has been changed wth duration less than 1 min'
    assert_equal 0, non_event_sub_corridor.light_status, 'Non event Sub corridor light status has been changed with duration less than 1 min'
    assert_equal 0, non_event_sub_corridor.ac_status, 'Non event Sub corridor ac status has been changed with duration less thatn 1 min'
    assert_operator floor.send(:current_consumption), :<=, floor.send(:max_consumption), 'Floor consumption is not maintained'

    new_duration = 1

    @controller.no_movement(event_floor_num, event_sub_corridor_num, new_duration)

    assert_equal 0, sub_corridor.light_status, 'Event Sub corridor light has not been turned off'
    assert_equal 1, sub_corridor.ac_status, 'Event Sub corridor AC has not been turned on'
    assert_equal 0, non_event_sub_corridor.light_status, 'Non event Sub corridor has light status on'
    assert_equal 1, non_event_sub_corridor.ac_status, 'Non event Sub corridor has ac status off'
    assert_same non_movement_floor, @controller.hotel.floors[2], 'Non movement floor status has been changed'
    assert_operator floor.send(:current_consumption), :<=, floor.send(:max_consumption), 'Floor consumption is not maintained'
	end
end