require 'spec_helper'

describe PagSeguro::Authorization do
  describe '.authorize' do
    it 'makes a successful authorization' do
      params = {
        appId: 'app123',
        appKey: 'adsada',
        notificationURL: "foo",
        redirectURL: "bar",
        permissions: "RECEIVE_TRANSACTION_NOTIFICATIONS,SEARCH_TRANSACTIONS"
      }

      PagSeguro::Request
        .should_receive(:post)
        .with('/authorizations/request', params)
        .and_return(double.as_null_object)

      PagSeguro::Authorization.authorize(
        { app_id: 'app123', app_key: 'adsada', permissions: [:notifications, :searches] },
        'foo',
        'bar'
        )
    end
  end
end
