require_relative 'floor'
require_relative 'lib/errors'

class Hotel
  include Errors
  attr_reader :floors

  def initialize(num_floors, each_num_main, each_num_sub)
    @num_floors = num_floors

    @floors = (1..num_floors).each_with_object({}) do |num, floors|
      floors[num] = Floor.new(each_num_main, each_num_sub)
    end
  end

  def send_movement_signal(floor_num, corridor_num)
    floor = floors[floor_num]
    return raise_no_floor_error if floor.nil?
    floor.movement(corridor_num)
  end

  def send_no_movement_signal(floor_num, corridor_num)
    floor = floors[floor_num]
    return raise_no_floor_error if floor.nil?
    floor.no_movement(corridor_num)
  end 

  def print_status
    @floors.map do |key, floor|
      floor.print_status(key)
    end
  end
end
