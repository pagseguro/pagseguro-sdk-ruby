require "spec_helper"

describe PagSeguro::Authorization::Serializer do
  let(:options) do
    {
      permissions: [:checkouts, :notifications],
      notification_url: 'foo.com',
      redirect_url: 'bar.com'
    }
  end
  let(:authorization) { PagSeguro::Authorization.new(options) }
  let(:serializer) { described_class.new(authorization) }
  let(:params) { serializer.to_params }

  it{ expect(params).to include(permissions: 'CREATE_CHECKOUTS,RECEIVE_TRANSACTION_NOTIFICATIONS') }
  it{ expect(params).to include(notificationURL: 'foo.com') }
  it{ expect(params).to include(redirectURL: 'bar.com') }
end
