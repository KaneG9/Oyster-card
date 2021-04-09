require_relative 'journey'

class JourneyLog
  attr_reader :journey_class, :journey

  def initialize
    @journey_class = Journey
    @journey
  end

  def start(station)
    @journey = @journey_class.new(station)
  end

  def finish(station)
    @journey.add_exit(station)
  end

  # private

  # def current_journey
  #   if @journey
  # end
end
