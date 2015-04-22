require 'spec_helper'

describe PagSeguro::AccountCredentials do
  describe 'credentials attributes' do
    credentials = PagSeguro::AccountCredentials.new('foo@bar.com', 'token')

    it { expect(credentials.email).to eq('foo@bar.com') }
    it { expect(credentials.token).to eq('token') }
  end
end
