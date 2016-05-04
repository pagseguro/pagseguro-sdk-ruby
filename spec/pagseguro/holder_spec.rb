require "spec_helper"

describe PagSeguro::Holder do
  it_assigns_attribute :name
  it_assigns_attribute :birth_date

  it_ensures_type PagSeguro::Document, :document
  it_ensures_type PagSeguro::Phone, :phone
  it_ensures_type PagSeguro::Address, :billing_address
end
