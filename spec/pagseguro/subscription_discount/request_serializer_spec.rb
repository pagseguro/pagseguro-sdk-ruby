require 'spec_helper'

describe PagSeguro::SubscriptionDiscount::RequestSerializer do
  context '#to_xml_params' do
    subject { described_class.new(discount) }

    let(:discount) { PagSeguro::SubscriptionDiscount.new }

    it 'should serializer type' do
      discount.type = 'DISCOUNT_AMOUNT'

      expect(subject.to_xml_params).to match %r[
        <directPreApproval>
          .*<type>DISCOUNT_AMOUNT
        ]xm
    end

    it 'should serializer value' do
      discount.value = 50

      expect(subject.to_xml_params).to match %r[
        <directPreApproval>
          .*<value>50.00
        ]xm
    end
  end
end
