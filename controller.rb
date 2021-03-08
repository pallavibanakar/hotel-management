require_relative 'hotel'
require 'csv'


class Controller
  attr_accessor :hotel

  def initialize(num_floor, num_main_corridor, num_sub_corridor)
    @hotel = Hotel.new(num_floor, num_main_corridor, num_sub_corridor)
  end

  def status
    @hotel.print_status
  end

  def movement(floor_num, corridor_num)
    @hotel.send_movement_signal(floor_num, corridor_num)
  end

  def no_movement(floor_num, corridor_num, duration)
    @hotel.send_no_movement_signal(floor_num, corridor_num) if duration >= 1
  end
end
