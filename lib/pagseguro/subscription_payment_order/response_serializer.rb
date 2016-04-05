module PagSeguro
  class SubscriptionPaymentOrder
    class ResponseSerializer
      attr_reader :xml

      def initialize(xml)
        @xml = xml
      end

      def serialize
        {}.tap do |data|
          data[:code] = xml.at_css('code').text
          data[:status] = SubscriptionPaymentOrder::STATUSES.key(xml.at_css('status').text.to_i)
          data[:amount] = to_amount xml.at_css('amount').text
          data[:gross_amount] = xml.at_css('grossAmount').text
          data[:scheduling_date] = Time.parse(xml.css('schedulingDate').text)
          data[:last_event_date] = Time.parse(xml.css('lastEventDate').text)
          data[:discount] = serialize_discount if xml.at_css('discount')
          data[:transaction] = serialize_transaction if xml.at_css('transactions')
        end
      end

      private

      def serialize_discount
        {}.tap do |data|
          data[:type] = xml.css('discount > type').text
          data[:value] = xml.css('discount > value').text
        end
      end

      def serialize_transaction
        {}.tap do |data|
          data[:code] = xml.css('transactions > code').text
          data[:date] = Time.parse(xml.css('transactions > date').text)
          data[:status] = SubscriptionTransaction::STATUSES.key(xml.css('transactions > status').text.to_i)
        end
      end

      def to_amount(amount)
        "%.2f" % BigDecimal(amount.to_s).round(2).to_s("F") if amount
      end
    end
  end
end
