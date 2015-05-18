require "spec_helper"

describe PagSeguro::Session do |variable|
  describe "#create" do
    let(:request) { double(:request) }
    let(:response) { double(:response) }

    before do
      expect(PagSeguro::Request).to receive(:post)
        .with("sessions", "v2")
        .and_return(request)
      expect(PagSeguro::Session::Response).to receive(:new)
        .with(request)
        .and_return(response)
    end

    context "when request succeeds" do
      let(:serialized_data) { {id: "123"} }

      it "creates a session" do
        expect(response).to receive(:serialize).and_return(serialized_data)
        expect(PagSeguro::Session).to receive(:new).with(serialized_data)

        PagSeguro::Session.create
      end
    end

    context "when request fails" do
      let(:serialized_data) { {errors: PagSeguro::Errors.new} }

      it "does not create a session" do
        expect(response).to receive(:serialize).and_return(serialized_data)
        expect(PagSeguro::Session).to receive(:new).with(serialized_data)

        PagSeguro::Session.create
      end
    end
  end
end
