require_relative 'corridor'
class SubCorridor < Corridor
  def initialize
    super({ light_status: 0, ac_status: 1 })
  end

  def trigger_movement
    switch_on_light
    switch_on_ac
  end

  def trigger_no_movement
    return if light_off?

    switch_off_light
  end
end
