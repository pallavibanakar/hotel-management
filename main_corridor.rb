require_relative 'corridor'

class MainCorridor < Corridor
  def initialize
    super({ light_status: 1, ac_status: 1 })
  end
end
