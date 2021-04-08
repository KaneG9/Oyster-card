require_relative 'journey'

class Oystercard
  attr_reader :balance, :entry_station, :history
  DEFAULT_VALUE = 0
  MAX_VALUE = 90
  MINIMUM_FARE = 1

  def initialize(balance = DEFAULT_VALUE, history = [])
    @balance = balance
    @history = history
    @current_journey = nil
  end

  def top_up(money)
    raise "Error: New balance over £#{MAX_VALUE}." if total(money) > MAX_VALUE
    @balance += money
  end

  def touch_in(station)
    raise "Error: Not enough money." if @balance < MINIMUM_FARE
    @current_journey = Journey.new(station)
  end

  def touch_out(exit_station)
    deduct(MINIMUM_FARE)
    @current_journey.add_exit(exit_station)
    add_to_history
    @current_journey = nil
  end

  def in_journey?
    @current_journey != nil
  end
  
  private
  def deduct(fare)
    @balance -= fare
  end

  def total(amount)
    @balance + amount
  end

  def add_to_history
    @history << @current_journey.log
  end
end
