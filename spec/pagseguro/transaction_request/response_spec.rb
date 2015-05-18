require "spec_helper"

describe PagSeguro::TransactionRequest::Response do
  let(:response) { double(:response) }
  subject { described_class.new(response) }

  describe "#serialize" do
    context "when request succeeds" do
      let(:serializer) { double(:serializer) }
      let(:serialized_data) { double(:serialized_data) }
      before do
        expect(response).to receive(:success?).and_return(true)
        expect(response).to receive(:xml?).and_return(true)
      end

      it "returns a hash with serialized response data" do
        expect(response).to receive(:body).and_return("")
        expect(PagSeguro::TransactionRequest::ResponseSerializer).to receive(:new)
          .and_return(serializer)
        expect(serializer).to receive(:serialize).and_return(serialized_data)

        expect(subject.serialize).to eq(serialized_data)
      end
    end

    context "when request fails" do
      before do
        expect(response).to receive(:success?).and_return(false)
      end

      it "returns a hash with an errors object" do
        expect(response).to receive(:unauthorized?).and_return(false)
        expect(response).to receive(:bad_request?).and_return(false)

        expect(subject.serialize[:errors]).to be_a(PagSeguro::Errors)
      end
    end
  end
end
