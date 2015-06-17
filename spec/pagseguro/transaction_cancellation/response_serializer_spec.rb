require "spec_helper"

describe PagSeguro::TransactionCancellation::ResponseSerializer do
  let(:raw_xml) { File.read("./spec/fixtures/transaction_cancellation/success.xml") }
  let(:xml) { Nokogiri::XML(raw_xml) }
  subject { PagSeguro::TransactionCancellation::ResponseSerializer.new(xml) }

  it { expect(subject.serialize).to include(result: "OK") }
end
