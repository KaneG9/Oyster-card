require 'oystercard'

describe Oystercard do
  let(:entry_station)  { double :station }
  let(:top_up) { subject.top_up(10) }
  let(:touch_in) { subject.touch_in(entry_station) }
  let(:history) { subject.history }
  let(:exit_station) { double :station }
  let(:clean_touch_out) do
    allow_any_instance_of(Journey).to receive(:log)
    .and_return({ :start_station => entry_station, :finish_station => exit_station })
    allow_any_instance_of(Journey).to receive(:fare).and_return Oystercard::MINIMUM_FARE
    subject.touch_out(exit_station)
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
      top_up
      touch_in
      expect(subject).to be_in_journey
    end

    it "Prevents you touching in below minimum value" do
      expect { subject.touch_in(entry_station) }.to raise_error("Error: Not enough money.")
    end

    it "Fine card if previous journey was not touched out" do
      allow_any_instance_of(Journey).to receive(:fare).and_return Oystercard::PENALTY_FARE 
      top_up
      touch_in
      expect { subject.touch_in(entry_station) }.to change { subject.balance }.by (-Oystercard::PENALTY_FARE)
    end
  end
  
  context "#touch_out" do
    it "ends journey when you touch out" do
      top_up
      touch_in
      clean_touch_out
      expect(subject).not_to be_in_journey
    end

    it "charges min fare on touch_out if completed journey" do
      top_up
      touch_in
      expect { clean_touch_out }.to change { subject.balance }.by(-Oystercard::MINIMUM_FARE)
    end

    it "Fine card if journey was not touched in" do
      top_up
      subject.touch_out(exit_station)
      expect { subject.touch_out(exit_station) }.to change { subject.balance }.by(-Oystercard::PENALTY_FARE)
    end
  end

  context "Journey history" do
    it "Card has empty list of journeys as default" do 
      expect(history).to eq []
    end

    it "touch in and touch out creates a journey" do
      top_up
      touch_in
      clean_touch_out
      expect(history).to eq([{ :start_station => entry_station, :finish_station => exit_station }])
    end
  end





end
