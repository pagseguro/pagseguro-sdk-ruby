require "spec_helper"

describe PagSeguro::TransactionRefund::ResponseSerializer do
  context "for existing refund response" do
    let(:source) { File.read("./spec/fixtures/refund/success.xml") }
    let(:xml) { Nokogiri::XML(source) }
    let(:serializer) { described_class.new(xml) }
    subject(:data) { serializer.serialize }

    it { expect(data).to include(result: "OK") }
  end
end
