require 'csv'
require_relative 'controller'
require_relative 'lib/constants'

def read_sensor_inputs(row)
  { movement_type: row['movement_type'],
    floor_num: row['floor']&.to_i,
    corridor_num: row['sub_corridor']&.to_i,
    duration: row['duration']&.to_i
  }
end

def print_sensor_inputs(event_input)
  puts("Sensor Inputs -> movement_type: #{event_input[:movement_type]}, floor: #{event_input[:floor_num]}, sub_corridor: #{event_input[:corridor_num]} duration: #{event_input[:duration]}")
end

def send_sensor_inputs(controller, event_input)
  case MOVEMENT_TYPE[:"#{event_input[:movement_type]}"]
  when 1
    controller.movement(event_input[:floor_num], event_input[:corridor_num])
  when 0
    controller.no_movement(event_input[:floor_num], event_input[:corridor_num], event_input[:duration])
  else
    puts("Wrong Movement Type. Please enter either of these movement types #{MOVEMENT_TYPE.keys}")
  end
rescue StandardError => e
  puts e
end

def read_internal_inputs(file)
  inputs = CSV.parse(File.read(file), headers: true)
  return inputs[0]['num_floor']&.to_i, inputs[0]['num_main_corridor']&.to_i, inputs[0]['num_sub_corridor']&.to_i
end

def execute_sensor_inputs(controller, file)
  CSV.parse(File.read(file), headers: true) do |row|
    event_input = read_sensor_inputs(row)
    print_sensor_inputs(event_input)
    send_sensor_inputs(controller, event_input)
    controller.status
  end
end

num_floor, num_main_corridor, num_sub_corridor = read_internal_inputs('csv/hotel_inputs.csv')
@main_controller = Controller.new(num_floor, num_main_corridor, num_sub_corridor)
puts('Initial State')
@main_controller.status
execute_sensor_inputs(@main_controller, 'csv/sensor_inputs.csv')
 