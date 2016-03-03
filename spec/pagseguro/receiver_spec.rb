require "spec_helper"

describe PagSeguro::Receiver do
  it_assigns_attribute :email
  it_assigns_attribute :public_key
  it_ensures_type PagSeguro::ReceiverSplit, :split
end
