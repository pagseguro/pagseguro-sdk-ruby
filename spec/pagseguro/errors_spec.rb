# -*- encoding: utf-8 -*-
require "spec_helper"

describe PagSeguro::Errors do
  let(:response) { double }
  let(:http_response) { double(:http_response, unauthorized?: true, bad_request?: false) }

  context "when have no response" do
    it "returns errors" do
      errors = PagSeguro::Errors.new
      expect(errors).to be_empty
    end
  end

  context "when unauthorized" do
    subject(:errors) { PagSeguro::Errors.new(response) }

    before do
      allow(response).to receive(:unauthorized?).and_return(true)
      allow(response).to receive(:bad_request?).and_return(false)

      errors.add(http_response)
    end

    it { expect(errors).not_to be_empty }
    it { expect(errors).to include(I18n.t("pagseguro.errors.unauthorized")) }
  end

  context "when message can't be translated" do
    let(:error) {
      <<-XML
        <errors>
          <error>
            <code>1234</code>
            <message>Sample message</message>
          </error>
        </errors>
      XML
    }

    let(:xml) { Nokogiri::XML(error) }
    subject(:errors) { PagSeguro::Errors.new(response) }

    before do
      allow(response).to receive(:data).and_return(xml)
      allow(response).to receive(:unauthorized?).and_return(false)
      allow(response).to receive(:bad_request?).and_return(true)
    end

    it { expect(errors).to include("Sample message") }
  end

  context "when message can be translated" do
    let(:error) {
      <<-XML
        <errors>
          <error>
            <code>10001</code>
            <message>Sample message</message>
          </error>
        </errors>
      XML
    }

    let(:xml) { Nokogiri::XML(error) }
    subject(:errors) { PagSeguro::Errors.new(response) }

    before do
      allow(response).to receive(:data).and_return(xml)
      allow(response).to receive(:unauthorized?).and_return(false)
      allow(response).to receive(:bad_request?).and_return(true)
    end

    it { expect(errors).to include("O parâmetro email deve ser informado.") }
  end

  context "when returning 404 status" do
    let(:error) {
      <<-XML
        <?xml version="1.0" encoding="UTF-8"?>
        <errors>
          <error>
              <code>Malformed request XML: {0}.</code>
              <message>Malformed request XML: XML document structures must start and end within the same entity..</message>
          </error>
        </errors>
      XML
    }

    let(:xml) { Nokogiri::XML(error) }
    subject(:errors) { PagSeguro::Errors.new(response) }

    before do
      allow(response).to receive(:data).and_return(xml)
      allow(response).to receive(:unauthorized?).and_return(false)
      allow(response).to receive(:bad_request?).and_return(true)

      errors.add(http_response)
    end

    it { expect(errors).to include("Malformed request XML: XML document structures must start and end within the same entity..") }
  end
end
