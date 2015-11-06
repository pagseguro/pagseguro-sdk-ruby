require "spec_helper"

describe PagSeguro::TransactionRefund::Response do
  let(:refund) do
    PagSeguro::TransactionRefund.new
  end

  subject { PagSeguro::TransactionRefund::Response.new(http_response, refund) }

  context '#success?' do
    let(:http_response) do
      double(:HttpResponse, xml?: true)
    end

    it 'delegate to response' do
      allow(http_response).to receive(:success?).and_return(true)
      expect(subject).to be_success

      allow(http_response).to receive(:success?).and_return(false)
      expect(subject).not_to be_success
    end
  end

  context '#serialize' do
    let(:http_response) do
      double(:HttpResponse, body: raw_xml, success?: true, xml?: true, unauthorized?: false, bad_request?: false)
    end

    let(:raw_xml) { File.read("./spec/fixtures/refund/success.xml") }

    it 'return refund instance' do
      expect(subject.serialize).to eq refund
    end

    it 'change result' do
      expect { subject.serialize }.to change { refund.result }
    end
  end
end
