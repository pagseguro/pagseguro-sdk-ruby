require "spec_helper"

describe PagSeguro::Items do
  it_behaves_like "Collection"

  context "adding a new item" do
    before do
      subject << item
    end

    let(:item) do
      PagSeguro::Item.new(id: 1234, description: "Tea", quantity: 1, amount: 300.0)
    end

    it "sets item" do
      expect(subject.size).to eql(1)
      expect(subject).to include(item)
    end

    it "sets item from Hash" do
      item_hash = { id: 4321 }
      subject << item_hash
      item = PagSeguro::Item.new(item_hash)

      expect(subject).to include(item)
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
