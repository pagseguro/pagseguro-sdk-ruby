require 'spec_helper'

describe PagSeguro::PaymentReleases do
  it "implements #each" do
    expect(PagSeguro::PaymentReleases.new).to respond_to(:each)
  end

  it "includes Enumerable" do
    expect(PagSeguro::PaymentReleases.included_modules).to include(Enumerable)
  end

  it "sets payment" do
    payment = PagSeguro::PaymentRelease.new
    payments = PagSeguro::PaymentReleases.new
    payments << payment

    expect(payments.size).to eql(1)
    expect(payments).to include(payment)
  end

  it "sets payment releases from Hash" do
    payment = PagSeguro::PaymentRelease.new(installment: 1)

    expect(PagSeguro::PaymentRelease).to(
      receive(:new)
      .with({installment: 1})
      .and_return(payment))

    payments = PagSeguro::PaymentReleases.new
    payments << {installment: 1}

    expect(payments).to include(payment)
  end
end
