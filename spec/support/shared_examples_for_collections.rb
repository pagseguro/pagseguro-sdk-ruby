RSpec.shared_examples 'Collection' do
  let(:object) { subject.collection_type.new }

  it 'includes Enumerable' do
    expect(described_class.included_modules).to include(Enumerable)
  end

  [
    :size,
    :clear,
    :empty?,
    :any?,
    :each,
    :map,
    :include?
  ].each do |method|
    it { is_expected.to respond_to(method) }
  end

  it 'should initialize empty' do
    expect(subject).to be_empty
  end

  it 'empties collection' do
    subject << object
    subject.clear

    expect(subject).to be_empty
  end

  it 'should not add the same object' do
    subject << object
    expect{ subject << object }.to_not change{ subject.size }
  end

  it 'includes an added object' do
    subject << object
    expect(subject).to include object
  end
end
