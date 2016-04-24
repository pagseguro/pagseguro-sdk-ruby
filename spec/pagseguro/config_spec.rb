require "spec_helper"

describe PagSeguro::Config do
  it_behaves_like "a configuration"

  it "should preserve values across threads" do
    PagSeguro.configure do |config|
      config.token = 'firsttoken'
      config.email = 'some@email.com'
    end

    thread = Thread.new do
      PagSeguro.configure do |config|
        config.token = 'secondtoken'
        config.email = 'other@email.com'
      end

      expect(PagSeguro.token).to eql('secondtoken')
    end

    thread.join

    expect(PagSeguro.token).to eql('firsttoken')
  end
end
