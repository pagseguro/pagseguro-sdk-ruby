require 'spec_helper'

RSpec.describe PagSeguro::Documents do
  it_behaves_like "Collection"

  context 'adding a new document' do
    let(:document) { { type: 'CPF', value: 11122233344 } }

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
