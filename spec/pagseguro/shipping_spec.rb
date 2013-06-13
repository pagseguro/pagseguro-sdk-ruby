require "spec_helper"

describe PagSeguro::Shipping do
  it_assigns_attribute :cost
  it_ensures_type PagSeguro::Address, :address

  PagSeguro::Shipping::TYPE.each do |name, id|
    it "sets id for name (#{id.inspect} => #{name.inspect})" do
      shipping = PagSeguro::Shipping.new(type_name: name)
      expect(shipping.type_id).to eql(id)
    end

    it "sets name for id (#{name.inspect} => #{id.inspect})" do
      shipping = PagSeguro::Shipping.new(type_id: id)
      expect(shipping.type_name).to eql(name)
    end
  end

  it "raises when setting an invalid type id" do
    shipping = PagSeguro::Shipping.new

    expect {
      shipping.type_id = 1234
    }.to raise_error(
      PagSeguro::Shipping::InvalidShippingTypeError,
      "invalid 1234 type id"
    )
  end

  it "raises when setting an invalid type name" do
    shipping = PagSeguro::Shipping.new

    expect {
      shipping.type_name = :invalid
    }.to raise_error(
      PagSeguro::Shipping::InvalidShippingTypeError,
      "invalid :invalid type name"
    )
  end
end
