require 'spec_helper'

describe PagSeguro::ManualSubscriptionCharger::RequestSerializer do
  context '#to_xml_params' do
    subject { described_class.new(charger) }

    let(:charger) { PagSeguro::ManualSubscriptionCharger.new }

    it 'should serializer reference' do
      charger.reference = 'ref-1234'

      expect(subject.to_xml_params).to match %r[
        <payment>
          .*<reference>ref-1234
        ]xm
    end

    it 'should serializer subscription code' do
      charger.subscription_code = '12345'

      expect(subject.to_xml_params).to match %r[
        <payment>
          .*<preApprovalCode>12345
        ]xm
    end

    context "serialize items'" do
      before do
        charger.items = items
      end

      subject do
        described_class.new(charger).to_xml_params
      end

      let(:items) do
        [
          { id: 669, description: 'Insurance', amount: 10.0, quantity: 1 }
        ]
      end

      it do
        is_expected.to match %r[
          <payment>
          .*<items>
            .*<item>
              .*<id>669
        ]xm
      end

      it do
        is_expected.to match %r[
          <payment>
          .*<items>
            .*<item>
              .*<description>Insurance
        ]xm
      end

      it do
        is_expected.to match %r[
          <payment>
          .*<items>
            .*<item>
              .*<quantity>1
        ]xm
      end

      it do
        is_expected.to match %r[
          <payment>
          .*<items>
            .*<item>
              .*<amount>10.00
        ]xm
      end
    end
  end
end
