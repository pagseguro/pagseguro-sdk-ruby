require "spec_helper"

RSpec.describe PagSeguro::Session::Response do
  let(:response) { double(:response, unauthorized?: false, bad_request?: false) }
  subject { described_class.new(response) }

  it "initialized with no errors" do
    expect(subject.errors).to be_empty
  end
end
