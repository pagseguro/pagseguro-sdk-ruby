module PagSeguro
  class Transaction
    class Serializer
      attr_reader :xml

      def initialize(xml)
        @xml = xml
      end

      def serialize
        {}.tap do |data|
          serialize_general(data)
          serialize_amounts(data)
          serialize_dates(data)
          serialize_creditor(data)
          serialize_payments(data)
          serialize_items(data)
          serialize_sender(data)
          serialize_shipping(data) if xml.css("shipping").any?
        end
      end

      def serialize_status_history
        xml.css("status").map do |node|
          PagSeguro::TransactionStatus.new(
            code: node.css("code").text,
            date: Time.parse(node.css("date").text),
            notification_code: node.css("notificationCode").text
          )
        end
      end

      private
      def serialize_general(data)
        data[:code] = xml.at_css("code").text
        data[:reference] = xml.css("reference").text
        data[:payment_link] = xml.css("paymentLink").text

        data[:type_id] = serialize_general_type_id
        data[:status] = serialize_general_status

        cancellation_source = xml.css("cancellationSource")
        data[:cancellation_source] = cancellation_source.text if cancellation_source.any?

        data[:payment_method] = {
          type_id: xml.css("paymentMethod > type").text,
          code: xml.css("paymentMethod > code").text
        }
      end

      def serialize_dates(data)
        data[:created_at] = Time.parse(xml.css("date").text)

        updated_at = xml.css("lastEventDate").text
        data[:updated_at] = Time.parse(updated_at) unless updated_at.empty?

        escrow_end_date = xml.css("escrowEndDate")
        data[:escrow_end_date] = Time.parse(escrow_end_date.text) if escrow_end_date.any?
      end

      def serialize_amounts(data)
        data[:gross_amount] = BigDecimal(xml.css("grossAmount").text.to_f.to_s)
        data[:discount_amount] = BigDecimal(xml.css("discountAmount").text.to_f.to_s)
        data[:net_amount] = BigDecimal(xml.css("netAmount").text.to_f.to_s)
        data[:extra_amount] = BigDecimal(xml.css("extraAmount").text.to_f.to_s)
        data[:installments] = xml.css("installmentCount").text.to_i
      end

      def serialize_creditor(data)
        data[:creditor_fees] = {
          intermediation_rate_amount: BigDecimal(xml.css("creditorFees > intermediationRateAmount").text.to_f.to_s),
          intermediation_fee_amount: BigDecimal(xml.css("creditorFees > intermediationFeeAmount").text.to_f.to_s),
          installment_fee_amount: BigDecimal(xml.css("creditorFees > installmentFeeAmount").text.to_f.to_s),
        }
        operational_fee_amount = xml.css("creditorFees > operationalFeeAmount").text.to_f.to_s
        data[:creditor_fees].merge!(operational_fee_amount: BigDecimal(operational_fee_amount)) if operational_fee_amount.present?

        commission_fee_amount = xml.css("creditorFees > commissionFeeAmount").text.to_f.to_s
        data[:creditor_fees].merge!(commission_fee_amount: BigDecimal(commission_fee_amount)) if commission_fee_amount.present?

        efrete = xml.css("creditorFees > efrete").text.to_f.to_s
        data[:creditor_fees].merge!(efrete: BigDecimal(efrete)) if efrete.present?
      end

      def serialize_payments(data)
        data[:payment_releases] = []

        xml.css("paymentReleases > paymentRelease").each do |node|
          payment_release = {}
          payment_release[:installment] = node.css("installment").text
          payment_release[:total_amount] = BigDecimal(node.css("totalAmount").text.to_f.to_s)
          payment_release[:release_amount] = BigDecimal(node.css("releaseAmount").text.to_f.to_s)
          payment_release[:status] = node.css("status").text
          payment_release[:release_date] = Time.parse(node.css("releaseDate").text)

          data[:payment_releases] << payment_release
        end
      end

      def serialize_items(data)
        data[:items] = []

        xml.css("items > item").each do |node|
          item = {}
          item[:id] = node.css("id").text
          item[:description] = node.css("description").text
          item[:quantity] = node.css("quantity").text.to_i
          item[:amount] = BigDecimal(node.css("amount").text.to_f.to_s)

          data[:items] << item
        end
      end

      def serialize_sender(data)
        sender = {
          name: xml.css("sender > name").text,
          email: xml.css("sender > email").text
        }

        serialize_phone(sender)
        serialize_document(sender)
        data[:sender] = sender
      end

      def serialize_document(data)
        data[:document] = {
          type: xml.css("sender > documents > document > type").text,
          value: xml.css("sender > documents > document > value").text
        }
      end

      def serialize_phone(data)
        data[:phone] = {
          area_code: xml.css("sender > phone > areaCode").text,
          number: xml.css("sender > phone > number").text
        }
      end

      def serialize_shipping(data)
        shipping = {
          type_id: xml.css("shipping > type").text,
          cost: BigDecimal(xml.css("shipping > cost").text.to_f.to_s),
        }

        serialize_address(shipping)
        data[:shipping] = shipping
      end

      def serialize_address(data)
        data[:address] = {
          street: address_node.css("> street").text,
          number: address_node.css("> number").text,
          complement: address_node.css("> complement").text,
          district: address_node.css("> district").text,
          city: address_node.css("> city").text,
          state: address_node.css("> state").text,
          country: address_node.css("> country").text,
          postal_code: address_node.css("> postalCode").text,
        }
      end

      def address_node
        @address_node ||= xml.css("shipping > address")
      end

      def serialize_general_type_id
        type = xml.css('type').detect do |node|
          node if node.parent.name == 'transaction'
        end

        type.text if type
      end

      def serialize_general_status
        status = xml.css('status').detect do |node|
          node if node.parent.name == 'transaction'
        end

        status.text if status
      end
    end
  end
end
