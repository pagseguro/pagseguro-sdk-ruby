require 'spec_helper'

describe PagSeguro::Credentials do
  describe 'initialize' do
    let(:crendentials) { PagSeguro::Credentials.new('1234', 'abcd') }

    it 'assigns app_id' do
      expect(crendentials.app_id).to eq('1234')
    end

    it 'assigns app_key' do
      expect(crendentials.app_key).to eq('abcd')
    end
  end
end
