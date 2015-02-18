# -*- encoding: utf-8 -*-
require "spec_helper"

describe PagSeguro::PreApproval::Serializer do
  context "for existing transactions" do
    let(:source) { File.read("./spec/fixtures/pre_approval/success.xml") }
    let(:xml) { Nokogiri::XML(source) }
    let(:serializer) { described_class.new(xml.css("preApproval").first) }
    subject(:data) { serializer.serialize }

    it { expect(data).to include(name: "Seguro contra roubo do Notebook Prata") }
    it { expect(data).to include(code: "C08984179E9EDF3DD4023F87B71DE349") }
    it { expect(data).to include(date: Time.parse("2011-11-23T13:40:23.000-02:00")) }
    it { expect(data).to include(tracker: "538C53") }
    it { expect(data).to include(status: "CANCELLED") }
    it { expect(data).to include(reference: "REF1234") }
    it { expect(data).to include(last_event_date: Time.parse("2011-11-25T20:04:23.000-02:00")) }
    it { expect(data).to include(charge: "auto") }

    it { expect(data[:sender]).to include(name: "Nome Comprador") }
    it { expect(data[:sender]).to include(email: "comprador@uol.com") }
    it { expect(data[:sender][:phone]).to include(area_code: "11") }
    it { expect(data[:sender][:phone]).to include(number: "30389678") }

    it { expect(data[:sender][:address]).to include(street: "ALAMEDA ITU") }
    it { expect(data[:sender][:address]).to include(number: "78") }
    it { expect(data[:sender][:address]).to include(complement: "ap. 2601") }
    it { expect(data[:sender][:address]).to include(district: "JardimPaulista") }
    it { expect(data[:sender][:address]).to include(city: "SAO PAULO") }
    it { expect(data[:sender][:address]).to include(state: "SP") }
    it { expect(data[:sender][:address]).to include(country: "BRASIL") }
    it { expect(data[:sender][:address]).to include(postal_code: "01421000") }

    end
end
