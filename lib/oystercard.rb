class Oystercard
  attr_reader :balance
  DEFAULT_VALUE = 0

  def initialize(balance = DEFAULT_VALUE)
    @balance = balance
  end
end