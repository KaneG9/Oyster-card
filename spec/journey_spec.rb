require "journey"

describe Journey do
  let(:entry_station) { double :entry }
  let(:subject) { Journey.new(entry_station) }
  let(:exit_station) { double :exit }

  it "Journey initalizes with entry station" do
    expect(subject.entry_station).to eq entry_station
  end

  it "Create a journey hash via add_exit" do
    j = Journey.new(entry_station)
    j.add_exit(exit_station)
    expect(j.journey).to eq({ entry_station => exit_station })
  end
end