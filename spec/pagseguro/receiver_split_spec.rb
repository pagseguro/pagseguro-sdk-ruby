require "spec_helper"

describe PagSeguro::ReceiverSplit do
  it_assigns_attribute :amount
  it_assigns_attribute :rate_percent
  it_assigns_attribute :fee_percent
end
