require_relative 'oystercard'

class Journey
  attr_reader :log

  def initialize(entry_station = nil)
    @log = {:start_station => entry_station}
  end

  def add_exit(exit_station)
    @log[:finish_station] = exit_station
  end 

  def fare
    Oystercard::MINIMUM_FARE
  end

end
