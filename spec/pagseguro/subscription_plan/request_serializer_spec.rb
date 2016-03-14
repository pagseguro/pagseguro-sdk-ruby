require 'spec_helper'

describe PagSeguro::SubscriptionPlan::RequestSerializer do
  context '#to_xml_params' do
    subject { described_class.new(plan) }

    let(:plan) { PagSeguro::SubscriptionPlan.new }

    it 'should serializer max users' do
      plan.max_users = 300

      expect(subject.to_xml_params).to match %r[
        <preApprovalRequest>
          .*<maxUsers>300
        ]xm
    end

    it 'should serializer name' do
      plan.name = 'Private channel access'

      expect(subject.to_xml_params).to match %r[
        <preApprovalRequest>
          .*<preApproval>
            .*<name>Private.channel.access
        ]xm
    end

    it 'should serializer charge' do
      plan.charge = 'AUTO'

      expect(subject.to_xml_params).to match %r[
        <preApprovalRequest>
          .*<preApproval>
            .*<charge>AUTO
        ]xm
    end

    it 'should serializer period' do
      plan.period = 'MONTHLY'

      expect(subject.to_xml_params).to match %r[
        <preApprovalRequest>
          .*<preApproval>
            .*<period>MONTHLY
        ]xm
    end

    it 'should serializer amount' do
      plan.amount = 80

      expect(subject.to_xml_params).to match %r[
        <preApprovalRequest>
          .*<preApproval>
            .*<amountPerPayment>80.00
        ]xm
    end

    it 'should serializer max amount' do
      plan.max_amount = 35_000

      expect(subject.to_xml_params).to match %r[
        <preApprovalRequest>
          .*<preApproval>
            .*<maxTotalAmount>35000.00
        ]xm
    end

    it 'should serializer final date' do
      plan.final_date = Date.new(2020, 12, 31)

      expect(subject.to_xml_params).to match %r[
        <preApprovalRequest>
          .*<preApproval>
            .*<finalDate>2020-12-31T00:00:000-03:00
        ]xm
    end

    it 'should serializer membership fee' do
      plan.membership_fee = 150

      expect(subject.to_xml_params).to match %r[
        <preApprovalRequest>
          .*<preApproval>
            .*<membershipFee>150.00
        ]xm
    end

    it 'should serializer trial duration' do
      plan.trial_duration = 30.0

      expect(subject.to_xml_params).to match %r[
        <preApprovalRequest>
          .*<preApproval>
            .*<trialPeriodDuration>30
        ]xm
    end
  end
end
