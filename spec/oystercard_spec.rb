require 'oystercard'

describe Oystercard do
  let(:journey_log_double) { double :journey_log }
  subject { Oystercard.new(Oystercard::DEFAULT_VALUE, journey_log = journey_log_double)}
  let(:entry_station)  { double :station }
  let(:top_up) { subject.top_up(10) }
  let(:touch_in) { subject.touch_in(entry_station) }
  let(:history) { subject.history }
  let(:exit_station) { double :station }
  let(:clean_touch_out) { subject.touch_out(exit_station) }
  let(:journey_double) { double :journey }

  it "card has balance of 0 at start" do
    expect(subject.balance).to eq 0
  end

  context "#top_up" do 
    it "adds money to balance" do
      expect { subject.top_up(10) }.to change { subject.balance }.by 10
    end
    
    it "error is new balance exceeds limit" do
      max = Oystercard::MAX_VALUE
      expect { subject.top_up(max + 1) }.to raise_error("Error: New balance over £#{max}.")
    end
  end

  context "#touch_in" do
    before do
      allow(journey_log_double).to receive(:in_journey?).and_return(false) 
      allow(journey_log_double).to receive(:start)
      allow(journey_log_double).to receive(:journey).and_return(journey_double)
    end

    it "Prevents you touching in below minimum value" do
      expect { subject.touch_in(entry_station) }.to raise_error("Error: Not enough money.")
    end

    it "Fine card if previous journey was not touched out" do
      allow(journey_log_double).to receive(:in_journey?).and_return(true)
      allow(journey_double).to receive(:fare).and_return(Oystercard::PENALTY_FARE)
      top_up
      touch_in
      expect { subject.touch_in(entry_station) }.to change { subject.balance }.by (-Oystercard::PENALTY_FARE)
    end
  end
  
  context "#touch_out" do
    before do
      allow(journey_log_double).to receive(:in_journey?).and_return(true) 
      allow(journey_log_double).to receive(:start)
      allow(journey_log_double).to receive(:finish)
      allow(journey_log_double).to receive(:journey).and_return(journey_double)
    end

    it "charges min fare on touch_out if completed journey" do
      allow(journey_double).to receive(:fare).and_return(Oystercard::MINIMUM_FARE)
      top_up
      touch_in
      expect { clean_touch_out }.to change { subject.balance }.by(-Oystercard::MINIMUM_FARE)
    end

    it "Fine card if journey was not touched in" do
      allow(journey_double).to receive(:fare).and_return(Oystercard::PENALTY_FARE)
      top_up
      subject.touch_out(exit_station)
      expect { subject.touch_out(exit_station) }.to change { subject.balance }.by(-Oystercard::PENALTY_FARE)
    end
  end
end
