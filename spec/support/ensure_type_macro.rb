module EnsureTypeMacro
  def it_ensures_type(klass, attr)
    it "ensures that #{attr.inspect} coerces hash to #{klass}" do
      options = double(:options)

      klass
        .should_receive(:new)
        .with(options)
        .and_return("INSTANCE")

      instance = described_class.new(attr => options)
      expect(instance.public_send(attr)).to eql("INSTANCE")
    end
  end
end

RSpec.configure {|c| c.extend(EnsureTypeMacro) }
