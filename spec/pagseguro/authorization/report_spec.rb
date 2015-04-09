# -*- encoding: utf-8 -*-
require "spec_helper"

describe PagSeguro::Authorization::Report do
  context "for checking authorization permissions" do
    let(:source) { File.read("./spec/fixtures/authorization/by_notification_code.xml") }
    let(:xml) { Nokogiri::XML(source) }
    let(:report) { described_class.new(xml) }
    let(:permissions) do
      [
        {
          code: 'CREATE_CHECKOUTS' ,
          status: 'APPROVED',
          last_update: '2011-03-30T15:35:44.000-03:00'
        },
        {
          code: 'SEARCH_TRANSACTIONS',
          status: 'APPROVED',
          last_update: '2011-03-30T14:20:13.000-03:00'
        }
      ]
    end

    describe '#code' do
      it {
        puts report.inspect
        expect(report.code).to eq("9D7FF2E921216F1334EE9FBEB7B4EBBC") }
    end

    describe '#reference' do
      it { expect(report.reference).to eq("ref1234") }
    end

    describe '#creation' do
      it { expect(report.created_at).to eq(Time.parse("2011-03-30T14:20:13.000-03:00")) }
    end

    describe '#authorizations' do
      it { expect(report.authorizations).to eq(permissions) }
    end
  end
end
