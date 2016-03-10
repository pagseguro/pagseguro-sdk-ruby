require 'spec_helper'

describe PagSeguro::SubscriptionPlan::ResponseSerializer do
  let(:source) { File.read('./spec/fixtures/subscription_plan/success.xml') }
  let(:xml) { Nokogiri::XML(source) }

  subject { described_class.new(xml) }

  it { expect(subject.serialize[:code]).to eql('12345') }
end
