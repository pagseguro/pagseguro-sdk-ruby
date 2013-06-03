module PagSeguro
  class Transaction
    class Serializer
      attr_reader :xml

      def initialize(xml)
        @xml = xml
      end

      def serialize
        {}.tap do |data|
          data[:created_at] = Time.parse(xml.css("date").text)
          data[:code] = xml.css(">code").text
          data[:reference] = xml.css("reference").text
          data[:type_id] = xml.css(">type").text

          updated_at = xml.css("lastEventDate").text
          data[:updated_at] = Time.parse(updated_at) unless updated_at.empty?

          data[:status] = xml.css("status").text

          cancellation_source = xml.css("cancellationSource")
          data[:cancellation_source] = cancellation_source.text if cancellation_source.any?

          escrow_end_date = xml.css("escrowEndDate")
          data[:escrow_end_date] = Time.parse(escrow_end_date.text) if escrow_end_date.any?

          data[:payment_method] = {
            type_id: xml.css("paymentMethod > type").text,
            code: xml.css("paymentMethod > code").text
          }

          data[:payment_link] = xml.css("paymentLink").text
          data[:gross_amount] = BigDecimal(xml.css("grossAmount").text)
          data[:discount_amount] = BigDecimal(xml.css("discountAmount").text)
          data[:fee_amount] = BigDecimal(xml.css("feeAmount").text)
          data[:net_amount] = BigDecimal(xml.css("netAmount").text)
          data[:extra_amount] = BigDecimal(xml.css("extraAmount").text)
          data[:installments] = xml.css("installmentCount").text.to_i

          serialize_items(data)
          serialize_sender(data)
          serialize_shipping(data) if xml.css("shipping").any?
        end
      end

      def serialize_items(data)
        data[:items] = []

        xml.css("items > item").each do |node|
          item = {}
          item[:id] = node.css("id").text
          item[:description] = node.css("description").text
          item[:quantity] = node.css("quantity").text.to_i
          item[:amount] = BigDecimal(node.css("amount").text)

          data[:items] << item
        end
      end

      def serialize_sender(data)
        sender = {
          name: xml.css("sender > name").text,
          email: xml.css("sender > email").text
        }

        serialize_phone(sender)
        data[:sender] = sender
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
          cost: BigDecimal(xml.css("shipping > cost").text),
        }

        serialize_address(shipping)
        data[:shipping] = shipping
      end

      def serialize_address(data)
        data[:address] = {
          street: xml.css("shipping > address > street").text,
          number: xml.css("shipping > address > number").text,
          complement: xml.css("shipping > address > complement").text,
          district: xml.css("shipping > address > district").text,
          city: xml.css("shipping > address > city").text,
          state: xml.css("shipping > address > state").text,
          country: xml.css("shipping > address > country").text,
          postal_code: xml.css("shipping > address > postalCode").text,
        }
      end
    end
  end
end
