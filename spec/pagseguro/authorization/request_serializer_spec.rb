require "spec_helper"

describe PagSeguro::Authorization::RequestSerializer do
  let(:credentials) { PagSeguro::ApplicationCredentials.new('app11', 'sada') }
  let(:options) { { credentials: credentials } }
  let(:serializer) { described_class.new(options) }
  let(:params) { serializer.to_params }

  it{ expect(params).to include(credentials: credentials) }
end
