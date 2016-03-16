require 'spec_helper'

describe PagSeguro::Subscription::ResponseSerializer do
  subject { PagSeguro::Subscription::ResponseSerializer.new(xml) }

  let(:source) { File.read('./spec/fixtures/subscription/success.xml') }
  let(:xml) { Nokogiri::XML(source) }

  it 'must return the code' do
    expect(subject.serialize).to eq({code: '12345'})
  end
end
