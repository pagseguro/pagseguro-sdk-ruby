require 'spec_helper'

describe PagSeguro::CreditorFee do
   it_assigns_attribute :intermediation_rate_amount
   it_assigns_attribute :intermediation_fee_amount
   it_assigns_attribute :installment_fee_amount
   it_assigns_attribute :operational_fee_amount
   it_assigns_attribute :commission_fee_amount
   it_assigns_attribute :efrete
end
