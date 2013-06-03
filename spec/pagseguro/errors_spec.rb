# -*- encoding: utf-8 -*-
require "spec_helper"

describe PagSeguro::Errors do
  let(:response) { double }

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

    it { expect(errors).to include("o parâmetro/valor não foi/foram informado(s)") }
  end
end
