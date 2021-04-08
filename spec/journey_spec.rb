require "journey"

describe Journey do
  let(:entry_station) { double :entry }
  let(:subject) { Journey.new(entry_station) }
  let(:exit_station) { double :exit }

  it "Journey initalizes with entry station" do
    expect(subject.entry_station).to eq entry_station
  end

  describe '#add_exit' do
    it "Create a journey hash via add_exit" do
      subject.add_exit(exit_station)
      expect(subject.journey).to eq({ entry_station => exit_station })
    end
  end
end