module MassAssignmentMacro
  def it_assigns_attribute(attr)
    it "assigns #{attr} on initialize" do
      value = attr.to_s.upcase
      object = described_class.new(attr => value)
      expect(object.public_send(attr)).to eql(value)
    end
  end
end

RSpec.configure {|c| c.extend(MassAssignmentMacro) }
