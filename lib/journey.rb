class Journey
  attr_reader :entry_station, :journey

  def initialize(entry_station = nil)
    @journey = {}
    @entry_station = entry_station
  end

  def add_exit(exit_station)
    @journey[@entry_station] = exit_station
  end 


end
