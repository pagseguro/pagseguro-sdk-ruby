require 'spec_helper'

RSpec.describe PagSeguro::Partner do
  it_assigns_attribute :name
  it_assigns_attribute :birth_date

  it_ensures_collection_type PagSeguro::Document, :documents, [{type: 'CPF', value: 12312312312}]
end
