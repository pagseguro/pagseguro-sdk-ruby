require 'spec_helper'

describe PagSeguro::AuthorizationRequest do
  describe '.create' do
    it 'creates an authorization' do
      params = {
        notificationURL: "foo",
        redirectURL: "bar",
        permissions: "RECEIVE_TRANSACTION_NOTIFICATIONS,SEARCH_TRANSACTIONS"
      }

      PagSeguro::Request
        .should_receive(:post)
        .with('authorizations/request', params)
        .and_return(double.as_null_object)

      PagSeguro::AuthorizationRequest.new(
          {
            permissions: [:notifications, :searches],
            notification_url: 'foo',
            redirect_url: 'bar'
          }).create
    end
  end
