require "spec_helper"

describe PagSeguro::AuthorizationRequest::RequestSerializer do
  let(:credentials) { PagSeguro::ApplicationCredentials.new('app11', 'sada') }
  let(:options) do
    {
      credentials: credentials,
      permissions: [:checkouts, :notifications],
      notification_url: 'foo.com',
      redirect_url: 'bar.com',
      reference: 'ref1234'
    }
  end
  let(:authorization) { PagSeguro::AuthorizationRequest.new(options) }
  let(:serializer) { described_class.new(authorization) }
  let(:params) { serializer.to_params }

  it{ expect(params).to include(credentials: credentials) }
  it{ expect(params).to include(permissions: 'CREATE_CHECKOUTS,RECEIVE_TRANSACTION_NOTIFICATIONS') }
  it{ expect(params).to include(notificationURL: 'foo.com') }
  it{ expect(params).to include(redirectURL: 'bar.com') }
  it{ expect(params).to include(reference: 'ref1234') }
end
