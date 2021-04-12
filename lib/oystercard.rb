require_relative 'journey'

require_relative "journey_log"

class Oystercard
  attr_reader :balance, :history, :current_journey
  DEFAULT_VALUE = 0
  MAX_VALUE = 90
  MINIMUM_FARE = 1
  PENALTY_FARE = 6

  def initialize(balance = DEFAULT_VALUE,  journey_log = JourneyLog.new)
    @balance = balance
    @journey_log = journey_log
  end

  def top_up(money)
    raise "Error: New balance over £#{MAX_VALUE}." if total(money) > MAX_VALUE
    @balance += money
  end

  def touch_in(station = nil)
    raise "Error: Not enough money." if @balance < MINIMUM_FARE
    penalty if in_journey?
    @journey_log.start(station)
  end

  def touch_out(exit_station)
    touch_in unless in_journey?
    @journey_log.finish(exit_station)
    deduct(current_journey.fare)
  end
  
  private
  def deduct(fare)
    @balance -= fare
  end

  def total(amount)
    @balance + amount
  end

  def penalty
    deduct(current_journey.fare) 
  end

  def current_journey
    @journey_log.journey
  end

  def in_journey?
    @journey_log.in_journey?
  end
end
