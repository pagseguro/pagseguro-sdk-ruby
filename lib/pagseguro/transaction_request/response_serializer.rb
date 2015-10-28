module PagSeguro
  class TransactionRequest
    class ResponseSerializer
      attr_reader :xml

      def initialize(xml)
        @xml = xml
      end

      def serialize
        {}.tap do |data|
          serialize_general(data)
          serialize_amounts(data)
          serialize_dates(data)
          serialize_items(data)
          serialize_sender(data)
          serialize_shipping(data) if xml.css("shipping").any?
        end
      end

      private
      def serialize_general(data)
        data[:code] = xml.css("> code").text
        data[:reference] = xml.css("reference").text
        data[:type_id] = xml.css("> type").text
        data[:payment_link] = xml.css("paymentLink").text
        data[:status] = xml.css("> status").text

        data[:payment_method] = {
          type_id: xml.css("paymentMethod > type").text,
          code: xml.css("paymentMethod > code").text
        }
      end

      def serialize_dates(data)
        data[:created_at] = Time.parse(xml.css("date").text)

        updated_at = xml.css("lastEventDate").text
        data[:updated_at] = Time.parse(updated_at) unless updated_at.empty?
      end

      def serialize_amounts(data)
        data[:gross_amount] = BigDecimal(xml.css("grossAmount").text)
        data[:discount_amount] = BigDecimal(xml.css("discountAmount").text)
        data[:net_amount] = BigDecimal(xml.css("netAmount").text)
        data[:extra_amount] = BigDecimal(xml.css("extraAmount").text)
        data[:installment_count] = xml.css("installmentCount").text.to_i
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
          cost: BigDecimal(xml.css("shipping > cost").text),
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
    end
  end
end
