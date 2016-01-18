require 'spec_helper'

RSpec.describe PagSeguro::Account do
  it_assigns_attribute :email
  it_assigns_attribute :type

  it_ensures_type PagSeguro::Company, :company
  it_ensures_type PagSeguro::Person, :person

  context 'only person or company should be assigned' do
    it "with company assigned, person can't be assigned too" do
      subject.company = PagSeguro::Company.new
      subject.person = PagSeguro::Person.new

      expect(subject.company).to be_a PagSeguro::Company
      expect(subject.person).to be_nil
    end

    it "with person assigned, company can't be assigned too" do
      subject.person = PagSeguro::Person.new
      subject.company = PagSeguro::Company.new

      expect(subject.person).to be_a PagSeguro::Person
      expect(subject.company).to be_nil
    end
  end
end
