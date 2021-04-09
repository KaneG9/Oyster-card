require 'journey_log'

describe JourneyLog do
  let(:start_station) { double('start station') }
  let(:end_station) { double('end station') }

  describe '#initialize' do
    it 'creates journey_class' do
      expect(subject.journey_class).to eq(Journey)
    end
  end

  describe '#start' do
    it 'starts a new journey with an entry station' do
      expect(subject).to respond_to(:start).with(1).argument
    end

    it 'adds an entry station to current journey' do
      subject.start(start_station)
      expect(subject.journey.log[:start_station]).to eq(start_station) 
    end
  end

  describe '#finish' do
    it 'finished a journey with an exit station' do
      expect(subject).to respond_to(:finish).with(1).argument
    end

    it 'adds an exit station to current journey' do
      subject.start(start_station)
      subject.finish(end_station)
      expect(subject.journey.log[:finish_station]).to eq(end_station) 
    end

    # it 'creates new journey if not started' do
    #   subject.finish(end_station)
    #   expected_journey = { 
    #     entry_station: nil,
    #     exit_station: end_station
    #   }
    #   expect(subject.journey).to eq(expected_journey)
    # end
  end
end
