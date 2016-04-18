require "spec_helper"

describe PagSeguro::Sender do
  it_assigns_attribute :name
  it_assigns_attribute :email
  it_assigns_attribute :hash
  it_assigns_attribute :ip

  it_ensures_type PagSeguro::Phone, :phone
  it_ensures_type PagSeguro::Address, :address

  it_ensures_collection_type PagSeguro::Document, :documents, [{type: 'CPF', value: 12312312312}]

  context 'when assign document' do
    it 'documents collection should increasing by 1' do
      expect{ subject.document = { type: 'CPF', value: 'VALUE' } }.to change{ subject.documents.size }.to 1
    end

    it 'document collection should have the document added' do
      subject.document = { type: 'CPF', value: 'VALUE' }
      expect(subject.documents.first).to eq PagSeguro::Document.new(type: 'CPF', value: 'VALUE')
    end
  end
end

