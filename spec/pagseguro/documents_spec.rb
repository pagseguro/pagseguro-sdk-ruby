require 'spec_helper'

RSpec.describe PagSeguro::Documents do
  [
    :size,
    :clear,
    :empty?,
    :any?,
    :each,
    :map
  ].each do |method|
    it { is_expected.to respond_to(method) }
  end

  it 'should initialize empty' do
    expect(subject).to be_empty
  end

  context 'adding a new document' do
    let(:document) { { type: 'CPF', value: 11122233344 } }

    it "shouldn't add the same document" do
      subject << document
      expect{ subject << document }.to_not change{ subject.size }
    end

    context 'ensures type the new document' do
      it 'can be a hash' do
        expect{ subject << document }.to change{ subject.size }.to(1)
      end

      it 'can be a PagSeguro::Document' do
        expect{ subject << PagSeguro::Document.new(type: 'CPF', value: 11122233344) }.to change{ subject.size }.to(1)
      end
    end
  end
end
