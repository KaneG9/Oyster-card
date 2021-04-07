require 'oystercard'

describe Oystercard do
  let(:station)  { double :station }
  let(:top_up_and_touch_in) do 
    subject.top_up(10)
    subject.touch_in(station)
  end

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
      top_up_and_touch_in
      expect(subject).to be_in_journey
    end

    it "Prevents you touching in below minimum value" do
      expect { subject.touch_in(station) }.to raise_error("Error: Not enough money.")
    end
  end
  
  context "#touch_out" do
    it "ends journey when you touch out" do
      top_up_and_touch_in
      subject.touch_out
      expect(subject).not_to be_in_journey
    end

    it "charges min fare on touch_out" do
      top_up_and_touch_in
      expect { subject.touch_out }.to change { subject.balance }.by(-Oystercard::MINIMUM_FARE)
    end
  end

  context "#entry_station" do
    it "remembers the entry station after the touch in" do
      top_up_and_touch_in
      expect(subject.entry_station).to eq station
    end

    it "forgets the entry station after touch out" do
      top_up_and_touch_in
      subject.touch_out
      expect(subject.entry_station).to eq nil
    end
  end
end
