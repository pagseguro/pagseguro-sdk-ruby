require "spec_helper"

RSpec.describe PagSeguro::Session::Response do
  let(:response) do
    double(:response, xml?: true, unauthorized?: false, bad_request?: false)
  end
  subject { described_class.new(response) }

  it "initializes with no errors" do
    expect(subject.errors).to be_empty
  end

  it "delegates .success? to response" do
    expect(response).to receive(:success?).and_return(true)
    expect(subject.success?).to be_truthy
  end

  describe ".parse" do
    before do
      expect(response).to receive(:success?).and_return(true)
      expect(subject).to receive(:serialize).and_return({id: "1"})
    end

    it "returns self" do
      expect(subject.parse).to eq(subject)
    end

    it "creates attributes accessors for serialized data" do
      subject.parse

      expect(subject.id).to eq("1")
    end
  end
end
