require 'journey_log'

describe JourneyLog do
  let(:journey_double) { double :journey }
  let(:subject) { JourneyLog.new(journey_double) }
  let(:start_station) { double('start station') }
  let(:end_station) { double('end station') }
  before { allow(journey_double).to receive(:new).and_return(journey_double) }
 

  describe '#start' do
    it 'starts a new journey with an entry station' do
      expect(subject).to respond_to(:start).with(1).argument
    end

    it 'adds an entry station to current journey' do
      expect(journey_double).to receive(:new).with(start_station)
      subject.start(start_station)
    end

    it "adds journey to log if previous journey not finished" do
      allow(journey_double).to receive(:completed?).and_return(false)
      subject.start(start_station)
      subject.start(start_station)
      expect(subject.journeys.last).to eq journey_double
    end
  end

  describe '#finish' do
    before { allow(journey_double).to receive(:add_exit) }
    it 'finished a journey with an exit station' do
      expect(subject).to respond_to(:finish).with(1).argument
    end

    it 'adds an exit station to current journey' do
      expect(journey_double).to receive(:add_exit).with(end_station)
      subject.start(start_station)
      subject.finish(end_station)
    end

    it "adds current_journey to journeys list" do
      subject.start(start_station)
      subject.finish(end_station)
      expect(subject.journeys.last).to eq journey_double
    end

    it "finish creates new journey if journey hasnt been started" do
      expect(journey_double).to receive(:new)
      subject.finish(end_station)
    end
  end
end
