require 'spec_helper'

describe PagSeguro::PaymentRelease do
   it_assigns_attribute :installment
   it_assigns_attribute :total_amount
   it_assigns_attribute :release_amount
   it_assigns_attribute :release_date
   it_assigns_attribute :status
end
