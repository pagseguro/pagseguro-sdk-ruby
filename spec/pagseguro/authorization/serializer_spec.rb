require "spec_helper"

describe PagSeguro::Authorization::Serializer do
  let(:credentials) do
    PagSeguro::Credentials.new(
      '1234456',
      'AKejPCCJeCIAMeqweR',
      'www.foo.com.br',
      'www.bar.io'
    )
  end
  let(:permissions) { %i(checkouts notifications) }
  let(:serializer) { described_class.new(credentials, permissions) }
  let(:params) { serializer.to_params }

  it{ expect(params).to include(appId: '1234456') }
  it{ expect(params).to include(appKey: 'AKejPCCJeCIAMeqweR') }
  it{ expect(params).to include(permissions: 'CREATE_CHECKOUTS,RECEIVE_TRANSACTION_NOTIFICATIONS') }
  it{ expect(params).to include(notificationUrl: 'www.foo.com.br') }
  it{ expect(params).to include(redirectUrl: 'www.bar.io') }

  context 'when the permissions are default' do
    it 'gives all permissions' do
      expect(described_class.new(credentials).to_params)
        .to include(permissions: 'CREATE_CHECKOUTS,RECEIVE_TRANSACTION_NOTIFICATIONS,SEARCH_TRANSACTIONS,MANAGE_PAYMENT_PRE_APPROVALS,DIRECT_PAYMENTS')
    end
  end
end
