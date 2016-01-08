require "spec_helper"

describe PagSeguro::Receiver do
  it_assigns_attribute :email
  it_ensures_type PagSeguro::ReceiverSplit, :split
end
