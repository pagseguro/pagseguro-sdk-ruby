require 'spec_helper'

describe PagSeguro::Credentials do
  describe 'initialize' do
    let(:crendentials) { PagSeguro::Credentials.new('1234', 'abcd', 'foo.com', 'bar.com') }

    it 'assigns app_id' do
      expect(crendentials.app_id).to eq('1234')
    end

    it 'assigns app_key' do
      expect(crendentials.app_key).to eq('abcd')
    end

    it 'assigns notification_url' do
      expect(crendentials.notification_url).to eq('foo.com')
    end

    it 'assigns redirect_url' do
      expect(crendentials.redirect_url).to eq('bar.com')
    end
  end
end
