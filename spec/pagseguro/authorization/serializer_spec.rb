require "spec_helper"

describe PagSeguro::Authorization::Serializer do
  let(:notification_url) { 'www.foo.com.br' }
  let(:redirect_url) { 'www.bar.io' }
  let(:permissions) { [:checkouts, :notifications] }
  let(:serializer) { described_class.new(notification_url, redirect_url, permissions) }
  let(:params) { serializer.to_params }

  it{ expect(params).to include(permissions: 'CREATE_CHECKOUTS,RECEIVE_TRANSACTION_NOTIFICATIONS') }
  it{ expect(params).to include(notificationURL: 'www.foo.com.br') }
  it{ expect(params).to include(redirectURL: 'www.bar.io') }

  context 'when the permissions are default' do
    it 'gives all permissions' do
      expect(described_class.new(notification_url, redirect_url).to_params)
        .to include(permissions: 'CREATE_CHECKOUTS,RECEIVE_TRANSACTION_NOTIFICATIONS,SEARCH_TRANSACTIONS,MANAGE_PAYMENT_PRE_APPROVALS,DIRECT_PAYMENTS')
    end
  end
end
