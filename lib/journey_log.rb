require_relative 'journey'

class JourneyLog
  attr_reader :journey_class, :journey

  def initialize(journey_class = Journey)
    @journey_class = journey_class
    @journey_history = []
  end

  def start(station)
    @journey_history << @journey unless @journey == nil || @journey.completed?
    @journey = @journey_class.new(station)
  end

  def finish(station)
    current_journey.add_exit(station)
    @journey_history << @journey
  end

  def journeys
    @journey_history.clone
  end

  def in_journey?
    return false if journey == nil
    !@journey.completed?
  end

  private

  def current_journey
    @journey ||= @journey_class.new
  end
end
