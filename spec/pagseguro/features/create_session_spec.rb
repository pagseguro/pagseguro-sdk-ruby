# encoding: utf-8
require "spec_helper"

RSpec.describe "Creating Session" do
  let(:session) { PagSeguro::Session.create }


  context "when request succeeds" do
    around do |example|
      PagSeguro.configure do |config|
        config.email = "EMAIL"
        config.token = "TOKEN"
        config.environment = :sandbox
      end

      VCR.use_cassette('create_session-success') { example.run }
    end

    it "returns a session object" do
      expect(session).to be_a(PagSeguro::Session)
    end

    describe "#errors" do
      it "is an errors object" do
        expect(session.errors).to be_a(PagSeguro::Errors)
      end

      it "has no errors" do
        expect(session.errors).to be_empty
      end
    end
  end

  context "when request fails" do
    around do |example|
      PagSeguro.configure do |config|
        config.email = "EMAIL-ERROR"
        config.token = "TOKEN-ERROR"
        config.environment = :sandbox
      end

      VCR.use_cassette('create_session-error') { example.run }
    end

    it "returns a session object" do
      expect(session).to be_a(PagSeguro::Session)
    end

    describe "#errors" do
      it "is an errors object" do
        expect(session.errors).to be_a(PagSeguro::Errors)
      end

      it "has errors" do
        expect(session.errors).to_not be_empty
        expect(session.errors).to include("Não autorizado.")
      end
    end
  end
end
