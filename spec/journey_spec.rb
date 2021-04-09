require "journey"

describe Journey do
  let(:entry_station) { double :entry }
  let(:subject) { Journey.new(entry_station) }
  let(:exit_station) { double :exit }

  context 'when initializing' do
    it "has an entry station" do
      expect(subject.log[:start_station]).to eq entry_station
    end
  end

  describe '#add_exit' do
    it "Create a journey hash via add_exit" do
      subject.add_exit(exit_station)
      expect(subject.log).to eq({ :start_station => entry_station, :finish_station => exit_station })
    end
  end

  describe '#fare' do
    it "returns the minimum fare if journey is complete" do
      subject.add_exit(exit_station)
      expect(subject.fare).to eq Oystercard::MINIMUM_FARE
    end

    it "returns penalty if no entry station" do
      j = Journey.new 
      expect(j.fare).to eq Oystercard::PENALTY_FARE
    end

    it "returns penalty if no exit station" do
      expect(subject.fare).to eq Oystercard::PENALTY_FARE
    end
  end

end