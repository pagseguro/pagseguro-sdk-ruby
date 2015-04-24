require "spec_helper"

describe PagSeguro::Permission do
  it_assigns_attribute :code
  it_assigns_attribute :status
  it_assigns_attribute :last_update
end
