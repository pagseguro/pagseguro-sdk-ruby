require 'spec_helper'

describe PagSeguro::SubscriptionChangeStatus::RequestSerializer do
  let(:object) do
    PagSeguro::SubscriptionChangeStatus.new(12345, :active)
  end

  subject { described_class.new(object) }

  context '#serialize' do
    it 'must serialize status' do
      expect(subject.serialize).to match %r[
        .*<directPreApproval>
          .*<status>ACTIVE</status>
        .*</directPreApproval>
      ]xm
    end
  end
end
