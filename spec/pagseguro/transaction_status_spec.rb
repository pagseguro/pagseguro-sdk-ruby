require 'spec_helper'

describe PagSeguro::TransactionStatus do
  it_assigns_attribute :code
  it_assigns_attribute :date
  it_assigns_attribute :notification_code
end
