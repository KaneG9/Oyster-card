require 'station'

describe Station do
  let(:subject) { Station.new(3, "Victoria") }

  it 'recognise the zone' do
    expect(subject.zone).to eq(3)
  end

  it 'recognise the name' do
    expect(subject.name).to eq("Victoria")
  end

end