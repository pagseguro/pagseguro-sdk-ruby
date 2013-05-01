require "spec_helper"

describe PagSeguro::Item do
  it_assigns_attribute :id
  it_assigns_attribute :description
  it_assigns_attribute :amount
  it_assigns_attribute :quantity
  it_assigns_attribute :weight
  it_assigns_attribute :shipping_cost

  it "sets default quantity" do
    item = PagSeguro::Item.new
    expect(item.quantity).to eql(1)
  end

  it "sets default weight" do
    item = PagSeguro::Item.new
    expect(item.weight).to be_zero
  end
end
