require_relative 'oystercard'

class Journey
  attr_reader :log

  def initialize(entry_station = nil)
    @log = {:start_station => entry_station, :finish_station => nil}
  end

  def add_exit(exit_station)
    @log[:finish_station] = exit_station
  end 

  def fare
    completed? ?  Oystercard::MINIMUM_FARE :  Oystercard::PENALTY_FARE
  end

  private
  def completed?
    @log[:start_station] != nil && @log[:finish_station] != nil
  end

end
