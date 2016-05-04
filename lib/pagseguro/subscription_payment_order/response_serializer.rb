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
          data[:transactions] = serialize_transactions if xml.css('transactions').any?
        end
      end

      private

      def serialize_discount
        {}.tap do |data|
          data[:type] = xml.css('discount > type').text
          data[:value] = xml.css('discount > value').text
        end
      end

      def serialize_transactions
        xml.css('transactions').map do |node|
          serialize_transaction(node)
        end
      end

      def serialize_transaction(node)
        {}.tap do |data|
          data[:code] = node.css('> code').text
          data[:date] = Time.parse(node.css('> date').text)
          data[:status] = SubscriptionTransaction::STATUSES.key(node.css('> status').text.to_i)
        end
      end

      def to_amount(amount)
        "%.2f" % BigDecimal(amount.to_s).round(2).to_s("F") if amount
      end
    end
  end
end
