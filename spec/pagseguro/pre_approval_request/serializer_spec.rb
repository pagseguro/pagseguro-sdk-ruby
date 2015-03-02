require "spec_helper"

describe PagSeguro::PreApprovalRequest::Serializer do
  let(:pre_approval_request) { PagSeguro::PreApprovalRequest.new }
  let(:params) { serializer.to_params }
  subject(:serializer) { described_class.new(pre_approval_request) }

  context "global configuration serialization" do
    before do
      PagSeguro.receiver_email = "RECEIVER"
    end

    it { expect(params).to include(receiverEmail: PagSeguro.receiver_email) }
  end

  context "generic attributes serialization" do
    before do
      pre_approval_request.stub({
        charge: "auto",
        name: "NAME",
        details: "DETAILS",
        amount_per_payment: 100.99,
        period: "MONTHLY",
        final_date: "2015-02-17T00:00:00-03:00",
        max_total_amount: 10000.99,
        reference: "REFERENCE",
        redirect_url: "REDIRECT_URL",
        review_url: "REVIEW_URL",        
      })
    end

    it { expect(params).to include(preApprovalCharge: "auto") }
    it { expect(params).to include(preApprovalName: "NAME") }
    it { expect(params).to include(preApprovalDetails: "DETAILS") }
    it { expect(params).to include(preApprovalAmountPerPayment: "100.99") }
    it { expect(params).to include(preApprovalPeriod: "MONTHLY") }
    it { expect(params).to include(preApprovalFinalDate: Time.parse("2015-02-17T00:00:00.0-03:00").iso8601(1)) }
    it { expect(params).to include(preApprovalMaxTotalAmount: "10000.99") }
    it { expect(params).to include(reference: "REFERENCE") }
    it { expect(params).to include(redirectURL: "REDIRECT_URL") }
    it { expect(params).to include(reviewURL: "REVIEW_URL") }
  end

  context "address serialization" do
    before do
      address = PagSeguro::Address.new({
        street: "STREET",
        state: "STATE",
        city: "CITY",
        postal_code: "POSTAL_CODE",
        district: "DISTRICT",
        number: "NUMBER",
        complement: "COMPLEMENT"
      })

      sender = double(address: address).as_null_object

      pre_approval_request.stub(
        sender: sender
      )
    end

    it { expect(params).to include(senderAddressStreet: "STREET") }
    it { expect(params).to include(senderAddressCountry: "BRA") }
    it { expect(params).to include(senderAddressState: "STATE") }
    it { expect(params).to include(senderAddressCity: "CITY") }
    it { expect(params).to include(senderAddressPostalCode: "POSTAL_CODE") }
    it { expect(params).to include(senderAddressDistrict: "DISTRICT") }
    it { expect(params).to include(senderAddressNumber: "NUMBER") }
    it { expect(params).to include(senderAddressComplement: "COMPLEMENT") }
  end

  context "sender serialization" do
    before do
      sender = PagSeguro::Sender.new({
        email: "EMAIL",
        name: "NAME",
        cpf: "CPF"
      })

      pre_approval_request.stub(sender: sender)
    end

    it { expect(params).to include(senderEmail: "EMAIL") }
    it { expect(params).to include(senderName: "NAME") }
    it { expect(params).to include(senderCPF: "CPF") }
  end

  context "phone serialization" do
    before do
      sender = PagSeguro::Sender.new({
        phone: {
          area_code: "AREA_CODE",
          number: "NUMBER"
        }
      })

      pre_approval_request.stub(sender: sender)
    end

    it { expect(params).to include(senderAreaCode: "AREA_CODE") }
    it { expect(params).to include(senderPhone: "NUMBER") }
  end

end
