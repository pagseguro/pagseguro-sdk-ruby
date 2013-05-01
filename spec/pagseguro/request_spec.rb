require "spec_helper"

describe PagSeguro::Request do
  context "default headers" do
    subject(:headers) { PagSeguro::Request.config.default_headers }

    it { should include("lib-description" => "ruby:#{PagSeguro::VERSION}") }
    it { should include("language-engine-description" => "ruby:#{RUBY_VERSION}") }
  end
end
