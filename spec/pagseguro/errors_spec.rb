# -*- encoding: utf-8 -*-
require "spec_helper"

describe PagSeguro::Errors do
  let(:response) { double }

  context "when have no response" do
    it "returns errors" do
      errors = PagSeguro::Errors.new
      expect(errors).to be_empty
    end
  end

  context "when unauthorized" do
    subject(:errors) { PagSeguro::Errors.new(response) }

    before do
      response.stub unauthorized?: true, bad_request?: false
    end

    it { should_not be_empty }
    it { should include(I18n.t("pagseguro.errors.unauthorized")) }
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
      response.stub data: xml, unauthorized?: false, bad_request?: true
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
      response.stub data: xml, unauthorized?: false, bad_request?: true
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
      response.stub data: xml, unauthorized?: false, bad_request?: true
    end

    it { expect(errors).to include("Malformed request XML: XML document structures must start and end within the same entity..") }
  end
end
