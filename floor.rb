require_relative 'main_corridor'
require_relative 'sub_corridor'
require_relative 'lib/errors'

class Floor
  include Errors
  attr_accessor :main_corridors, :sub_corridors

  def initialize(no_of_main, no_of_sub)
    @num_main = no_of_main
    @num_sub = no_of_sub
    @main_corridors = init_main_corridors(no_of_main)
    @sub_corridors = init_sub_corridors(no_of_sub)
  end

  def movement(corridor_num)
    find_sub_corridor(corridor_num).trigger_movement
    rectify_consumption(corridor_num)
  end

  def no_movement(corridor_num)
    find_sub_corridor(corridor_num).trigger_no_movement
    rectify_consumption(corridor_num)
  end

  def print_status(floor_num)
    puts("Floor #{floor_num}")
    [main_corridors, sub_corridors].each do |corridors|
      corridors.map { |num, corridor| corridor.print_status(num) }
    end
  end

  def rectify_consumption(event_corridor_num)
    max_consumption_value = max_consumption
    if current_consumption > max_consumption_value
      alternate_corridor(event_corridor_num).switch_off_ac while current_consumption >= max_consumption_value
    else
      new_consumption = current_consumption + AC_CONSUMPTION
      while new_consumption <= max_consumption_value
        ac_off_corridor.switch_on_ac
        new_consumption += AC_CONSUMPTION
      end
    end
  end

  private

  def init_main_corridors(no_of_main)
    (1..no_of_main).each_with_object({}) { |num, main_corridors| main_corridors[num] = MainCorridor.new }
  end

  def init_sub_corridors(no_of_sub)
    (1..no_of_sub).each_with_object({}) { |num, sub_corridors| sub_corridors[num] = SubCorridor.new }
  end

  def find_sub_corridor(sub_corridor_num)
    sub_corridor = sub_corridors[sub_corridor_num]
    raise_no_corridor_error if sub_corridor.nil?
    sub_corridor
  end

  def current_consumption
    [@main_corridors.values, @sub_corridors.values].flatten.inject(0) do |consumption, corridor|
      consumption + corridor.consumption
    end
  end

  def max_consumption
    (@num_main * MAIN_CORRIDOR_INITIAL_CONSUMPTION) + (@num_sub * SUB_CORRIDOR_INITIAL_CONSUMPTION)
  end

  def no_movement_sub_corridor
    sub_corridors.map do |_key, sub_corridor|
      return sub_corridor if sub_corridor.light_off?
    end
  end

  def alternate_corridor(triggered_corridor_num)
    sub_corridors.map do |key, sub_corridor|
      return sub_corridor unless (key.eql?(triggered_corridor_num) || sub_corridor.ac_off?)
    end
  end

  def ac_off_corridor
    sub_corridors.map do |_key, sub_corridor|
      return sub_corridor if sub_corridor.ac_off?
    end
  end
end
