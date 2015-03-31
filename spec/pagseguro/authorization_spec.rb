require 'spec_helper'

describe PagSeguro::Authorization do
  describe '.authorize' do
    it 'makes a successful authorization' do
      params = {
        notificationURL: "foo",
        redirectURL: "bar",
        permissions: "RECEIVE_TRANSACTION_NOTIFICATIONS,SEARCH_TRANSACTIONS"
      }

      PagSeguro::Request
        .should_receive(:post)
        .with('/authorizations/request', params)
        .and_return(double.as_null_object)

      PagSeguro::Authorization.authorize('foo', 'bar', [:notifications, :searches])
    end
  end
end
