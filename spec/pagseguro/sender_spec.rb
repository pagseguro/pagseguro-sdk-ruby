require "spec_helper"

describe PagSeguro::Sender do
  it_assigns_attribute :name
  it_assigns_attribute :email
  it_assigns_attribute :cpf
  it_assigns_attribute :hash
  it_assigns_attribute :ip

  it_ensures_type PagSeguro::Phone, :phone
  it_ensures_type PagSeguro::Document, :document
  it_ensures_type PagSeguro::Address, :address
end

