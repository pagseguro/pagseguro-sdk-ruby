require "spec_helper"

describe PagSeguro::Session::ResponseSerializer do
  context "when there are installments" do
    let(:source) { File.read("./spec/fixtures/session/success.xml") }
    let(:xml) { Nokogiri::XML(source) }
    let(:serializer) { described_class.new(xml.css("session").first) }
    subject(:data) { serializer.serialize }

    it { expect(data).to include(id: "620f99e348c24f07877c927b353e49d3") }
  end
end
