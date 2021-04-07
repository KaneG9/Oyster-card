class Oystercard
  attr_reader :balance, :entry_station, :history
  DEFAULT_VALUE = 0
  MAX_VALUE = 90
  MINIMUM_FARE = 1

  def initialize(balance = DEFAULT_VALUE, entry_station = nil, history = [])
    @balance = balance
    @entry_station = entry_station
    @history = history
   
  end

  def top_up(money)
    raise "Error: New balance over £#{MAX_VALUE}." if total(money) > MAX_VALUE
    @balance += money
  end

  def touch_in(station)
    raise "Error: Not enough money." if @balance < MINIMUM_FARE
    @entry_station = station
  end

  def touch_out(exit_station)
    deduct(MINIMUM_FARE)
    add_to_history(exit_station)
    @entry_station = nil
  end

  def in_journey?
    @entry_station != nil
  end
  
  private
  def deduct(fare)
    @balance -= fare
  end

  def total(amount)
    @balance + amount
  end

  def add_to_history(exit_station)
    @history << { @entry_station => exit_station }
  end
end
