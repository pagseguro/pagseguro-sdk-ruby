require "spec_helper"

describe PagSeguro::Authorization::Serializer do
  let(:options) do
    {
      app_id: 'app12345',
      app_key: 'KAdjfeAI3',
      permissions: [:checkouts, :notifications]
    }
  end
  let(:authorization) { PagSeguro::Authorization.new(options) }
  let(:serializer) { described_class.new(authorization, 'foo.com', 'bar.com') }
  let(:params) { serializer.to_params }

  it{ expect(params).to include(permissions: 'CREATE_CHECKOUTS,RECEIVE_TRANSACTION_NOTIFICATIONS') }
  it{ expect(params).to include(notificationURL: 'foo.com') }
  it{ expect(params).to include(redirectURL: 'bar.com') }
end
