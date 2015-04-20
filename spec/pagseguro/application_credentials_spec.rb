require 'spec_helper'

describe PagSeguro::ApplicationCredentials do
  describe 'credentials attributes' do
    credentials = PagSeguro::ApplicationCredentials.new('app123', 'qwerty')

    it { expect(credentials.app_id).to eq('app123') }
    it { expect(credentials.app_key).to eq('qwerty') }
    it { expect(credentials.authorization_code).to be_nil }
  end
end
