require "spec_helper"

describe PagSeguro::Authorization::Response do
  subject { described_class.new(response, object) }

  describe "#serialize_collection" do
    let(:xml) { File.read("./spec/fixtures/authorization/search_authorization.xml") }
    let(:object) { PagSeguro::Authorization::Collection.new }
    let(:response) do
      double(
        :Response,
        body: xml,
        code: 200,
        success?: true,
        xml?: true
      )
    end

    context "when request succeeds" do
      it "does not return a empty collection" do
        expect { subject.serialize_collection }.not_to change { object.errors.empty? }
      end

      it "must have only PagSeguro::Authorization" do
        subject.serialize_collection

        object.each do |authorization|
          expect(authorization).to be_a_kind_of PagSeguro::Authorization
        end
      end
    end

    context "when request fails" do
      let(:response) do
        double(
          :Response,
          body: xml,
          code: 403,
          xml?: true,
          success?: false,
          error?: true,
          error: Aitch::ForbiddenError
        )
      end

      it "serialize errors" do
        expect { subject.serialize_collection }.to change { object.errors.empty? }
      end
    end
  end

  describe "#serialize" do
    let(:xml) { File.read("./spec/fixtures/authorization/find_authorization.xml") }
    let(:object) { PagSeguro::Authorization.new }

    context "when request succeeds" do
      let(:response) do
        double(
          :Response,
          body: xml,
          code: 200,
          xml?: true,
          success?: true,
        )
      end

      it "returns a hash with serialized response data" do
        expect { subject.serialize }.to change { object.code }.to('9D7FF2E921216F1334EE9FBEB7B4EBBC')
      end
    end

    context "when request fails" do
      let(:response) do
        double(
          :Response,
          body: xml,
          code: 404,
          xml?: true,
          success?: false,
          error?: true,
          error: Aitch::NotFoundError
        )
      end

      it "serialize errors" do
        expect { subject.serialize }.to change { object.errors.empty? }
      end
    end
  end
end
