module PagSeguro
  class PaymentStatus
    STATUSES = {
      "0" => :initiated,
      "1" => :waiting_payment,
      "2" => :in_analysis,
      "3" => :paid,
      "4" => :available,
      "5" => :in_dispute,
      "6" => :refunded,
      "7" => :cancelled,
      "8" => :chargeback_charged,
      "9" => :contested
    }.freeze

    # The payment status id.
    attr_reader :id

    def initialize(id)
      @id = id
    end

    # Dynamically define helpers.
    STATUSES.each do |id, _status|
      define_method "#{_status}?" do
        _status == status
      end
    end

    # Return a readable status.
    def status
      STATUSES.fetch(id.to_s) { raise "PagSeguro::PaymentStatus#id isn't mapped" }
    end
  end
end
