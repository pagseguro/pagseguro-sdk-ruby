require "spec_helper"

describe PagSeguro::AuthorizationRequest::ResponseSerializer do
  context "when payment request is created" do
    let(:source) { File.read("./spec/fixtures/authorization_request/success.xml") }
    let(:xml) { Nokogiri::XML(source) }
    let(:serializer) { described_class.new(xml.css("authorizationRequest").first) }

    subject(:data) { serializer.serialize }

    it { expect(data[:code]).to eql("D8DD848AC9C98D9EE44C5FB3A1E53913") }
    it { expect(data[:date]).to eql(Time.parse("2011-02-25T11:40:50.000-03:00")) }
  end
end

