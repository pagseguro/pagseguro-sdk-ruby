require 'spec_helper'

describe PagSeguro::ManualSubscriptionCharger::ResponseSerializer do
  let(:source) { File.read('./spec/fixtures/manual_subscription_charger/success.xml') }
  let(:xml) { Nokogiri::XML(source) }

  subject { described_class.new(xml) }

  it { expect(subject.serialize[:transaction_code]).to eql('D9AD1EA3DEB544A6A413E33BD4822225') }
end
