require "spec_helper"

describe PagSeguro::Address do
  it_assigns_attribute :street
  it_assigns_attribute :number
  it_assigns_attribute :complement
  it_assigns_attribute :district
  it_assigns_attribute :city
  it_assigns_attribute :state
  it_assigns_attribute :country
  it_assigns_attribute :postal_code

  it "sets default country" do
    address = PagSeguro::Address.new
    expect(address.country).to eql("BRA")
  end
end
