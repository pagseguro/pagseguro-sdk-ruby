require "spec_helper"

describe PagSeguro::Items do
  it "implements #each" do
    expect(PagSeguro::Items.new).to respond_to(:each)
  end

  it "implements #any" do
    expect(PagSeguro::Items.new).to respond_to(:any?)
  end

  it "includes Enumerable" do
    expect(PagSeguro::Items.included_modules).to include(Enumerable)
  end

  it "sets item" do
    item = PagSeguro::Item.new
    items = PagSeguro::Items.new
    items << item

    expect(items.size).to eql(1)
    expect(items).to include(item)
  end

  it "sets item from Hash" do
    item = PagSeguro::Item.new(id: 1234)

    PagSeguro::Item
      .should_receive(:new)
      .with({id: 1234})
      .and_return(item)

    items = PagSeguro::Items.new
    items << {id: 1234}

    expect(items).to include(item)
  end

  it "increases quantity when adding duplicated item" do
    item = PagSeguro::Item.new(id: 1234)
    items = PagSeguro::Items.new
    items << item
    items << item

    expect(items.size).to eql(1)
    expect(item.quantity).to eql(2)
  end

  it "empties items" do
    items = PagSeguro::Items.new
    items << {id: 1234}
    items.clear

    expect(items).to be_empty
  end
end
