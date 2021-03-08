require_relative 'lib/constants'

class Corridor
  attr_accessor :light_status, :ac_status

  def initialize(electronics)
    electronics.each do |k, v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end

  %w[light ac].each do |electronic|
    define_method(:"switch_on_#{electronic}") do
      instance_variable_set("@#{electronic}_status", 1)
    end

    define_method(:"switch_off_#{electronic}") do
      instance_variable_set("@#{electronic}_status", 0)
    end

    define_method(:"#{electronic}_off?") do
      instance_variable_get("@#{electronic}_status").zero?
    end

    define_method(:"#{electronic}_on?") do
      instance_variable_get("@#{electronic}_status") == 1
    end
  end

  def consumption
    @light_status * LIGHT_CONSUMPTION + @ac_status * AC_CONSUMPTION
  end

  def print_status(num)
    puts("#{self.class} #{num} Light #{num} : #{STATUS[@light_status]} AC : #{STATUS[@ac_status]}")
  end
end
