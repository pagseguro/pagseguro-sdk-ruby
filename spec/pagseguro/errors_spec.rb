require "spec_helper"

describe PagSeguro::Errors do
  let(:response) { stub }
  subject(:errors) { PagSeguro::Errors.new(response) }

  context "when unauthorized" do
    before do
      response.stub unauthorized?: true, bad_request?: false
    end

    it { should_not be_empty }
    it { should include(I18n.t("pagseguro.errors.unauthorized")) }
  end
end
