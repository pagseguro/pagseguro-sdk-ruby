require "spec_helper"

describe PagSeguro::Authorization::ResponseSerializer do
  context "when payment request is created" do
    let(:source) { File.read("./spec/fixtures/authorization/find_authorization.xml") }
    let(:xml) { Nokogiri::XML(source) }
    let(:serializer) { described_class.new(xml.css("authorization").first) }

    subject(:data) { serializer.serialize }

    it { expect(data[:code]).to eql("9D7FF2E921216F1334EE9FBEB7B4EBBC") }
    it { expect(data[:created_at]).to eql(Time.parse("2011-03-30T14:20:13.000-03:00")) }
    it { expect(data[:reference]).to eql("ref1234") }
    it { expect(data[:permissions]).to be_a(Array) }
    it { expect(data[:permissions].first.code).to eq("CREATE_CHECKOUTS") }
    it { expect(data[:permissions].first.status).to eq("APPROVED") }
  end
end

