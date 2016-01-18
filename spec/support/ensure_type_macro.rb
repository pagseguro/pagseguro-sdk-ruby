module EnsureTypeMacro
  def it_ensures_type(klass, attr)
    it "ensures that #{attr.inspect} coerces hash to #{klass}" do
      options = double(:options)

      expect(klass)
        .to receive(:new)
        .with(options)
        .and_return("INSTANCE")

      instance = described_class.new(attr => options)
      expect(instance.public_send(attr)).to eql("INSTANCE")
    end
  end

  def it_ensures_collection_type(klass, attr, options)
    context "ensures that ##{attr} coerces a collection and return" do
      before do
        subject.send("#{attr}=", options)
      end

      it "correct count of objects" do
        expect(subject.send(attr).size).to eq options.size
      end

      it "all objects of #{attr} should be an instance of #{klass}" do
        subject.send(attr).each do |object|
          expect(object).to be_an_instance_of klass
        end
      end
    end
  end
end

RSpec.configure {|c| c.extend(EnsureTypeMacro) }
