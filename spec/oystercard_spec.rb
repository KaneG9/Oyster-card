require 'oystercard'

describe Oystercard do
  let(:entry_station)  { double :station }
  let(:top_up) { subject.top_up(10) }
  let(:touch_in) { subject.touch_in(entry_station) }
  let(:history) { subject.history }
  let(:exit_station) { double :station }

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
    it "starts journey when you touch in" do
      top_up
      touch_in
      expect(subject).to be_in_journey
    end

    it "Prevents you touching in below minimum value" do
      expect { subject.touch_in(entry_station) }.to raise_error("Error: Not enough money.")
    end
  end
  
  context "#touch_out" do
    it "ends journey when you touch out" do
      top_up
      touch_in
      subject.touch_out(exit_station)
      expect(subject).not_to be_in_journey
    end

    it "charges min fare on touch_out" do
      top_up
      touch_in
      expect { subject.touch_out(exit_station) }.to change { subject.balance }.by(-Oystercard::MINIMUM_FARE)
    end
  end

  context "Journey history" do
    it "Card has empty list of journeys as default" do 
      expect(history).to eq []
    end

    it "touch in and touch out creates a journey" do
      top_up
      touch_in
      subject.touch_out(exit_station)
      expect(history).to eq [{ entry_station => exit_station }]
    end
  end
end
