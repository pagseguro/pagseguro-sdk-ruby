require 'spec_helper'

RSpec.describe PagSeguro::Company do
  it_assigns_attribute :name
  it_assigns_attribute :display_name
  it_assigns_attribute :website_url

  it_ensures_type PagSeguro::Address, :address
  it_ensures_type PagSeguro::Partner, :partner
  it_ensures_collection_type PagSeguro::Document, :documents, [{type: 'CPF', value: 12312312312}]
  it_ensures_collection_type PagSeguro::Phone, :phones, [{type: 'HOME', area_code: 11, number: 12312312312}]
end
