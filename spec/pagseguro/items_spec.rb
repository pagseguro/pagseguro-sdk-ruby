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

    expect(PagSeguro::Item)
      .to receive(:new)
      .with({id: 1234})
      .and_return(item)

    items = PagSeguro::Items.new
    items << {id: 1234}

    expect(items).to include(item)
  end

  it "empties items" do
    items = PagSeguro::Items.new
    items << {id: 1234}
    items.clear

    expect(items).to be_empty
  end

  context "#<<" do
    before do
      subject << item
    end

    subject do
      PagSeguro::Items.new
    end

    let(:item) do
      PagSeguro::Item.new(id: 1234, description: "Tea", quantity: 1, amount: 300.0)
    end

    context "when add same item" do
      context "and no quantity is informed" do
        let(:other_item) do
          { id: 1234, description: "Tea", amount: 300.0 }
        end

        it "increases one in item quantity" do
          expect { subject << other_item }.to change { item.quantity }.by(1)
        end

        it "does not increase items size" do
          expect { subject << other_item }.not_to change { subject.size }
        end
      end

      context "and quantity is informed" do
        let(:other_item) do
          { id: 1234, description: "Tea", quantity: 20, amount: 300.0 }
        end

        it "increases item quantity" do
          expect { subject << other_item }.to change { item.quantity }.by(20)
        end

        it "does not increase items size" do
          expect { subject << other_item }.not_to change { subject.size }
        end
      end
    end

    context "when add different item" do
      context "with only description equals" do
        let(:other_item) do
          { id: 4321, description: "Tea" }
        end

        it "does not increase item quantity" do
          expect { subject << other_item }.not_to change { item.quantity }
        end

        it "increases items size" do
          expect { subject << other_item }.to change { subject.size }.by(1)
        end
      end

      context "with only id equals" do
        let(:other_item) do
          { id: 1234, description: "Coffee" }
        end

        it "does not increase item quantity" do
          expect { subject << other_item }.not_to change { item.quantity }
        end

        it "increases subject size" do
          expect { subject << other_item }.to change { subject.size }.by(1)
        end
      end

      context "with only amount equals" do
        let(:other_item) do
          { id: 4321, description: "Coffee", amount: 300.0 }
        end

        it "does not increase item quantity" do
          expect { subject << other_item }.not_to change { item.quantity }
        end

        it "increases subject size" do
          expect { subject << other_item }.to change { subject.size }.by(1)
        end
      end

      context "with id and description different" do
        let(:other_item) do
          { id: 4321, description: "Coffee" }
        end

        it "does not increase item quantity" do
          expect { subject << other_item }.not_to change { item.quantity }
        end

        it "increases subject size" do
          expect { subject << other_item }.to change { subject.size }.by(1)
        end
      end
    end
  end
end
