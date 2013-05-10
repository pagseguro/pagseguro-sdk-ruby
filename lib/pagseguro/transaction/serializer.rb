module PagSeguro
  class Transaction
    class Serializer
      def initialize(response)
        @response = response
      end

      def serialize
        if @response.success?
          process_success_response
        else
          process_failed_response
        end
      end

      private
      def process_failed_response
        {
          errors: PagSeguro::Errors.new(@response)
        }
      end

      def process_success_response
        {}.tap do |data|
          data[:created_at] = Time.parse(xml.css("transaction > date").text)
          data[:code] = xml.css("transaction > code").text
          data[:reference] = xml.css("transaction > reference").text
          data[:type_id] = xml.css("transaction > type").text
          data[:updated_at] = Time.parse(xml.css("transaction > lastEventDate").text)
          data[:status_id] = xml.css("transaction > status").text

          cancellation_source = xml.css("transaction > cancellationSource")
          data[:cancellation_source] = cancellation_source.text if cancellation_source.any?

          escrow_end_date = xml.css("transaction > escrowEndDate")
          data[:escrow_end_date] = Time.parse(escrow_end_date.text) if escrow_end_date.any?

          data[:payment_method] = {
            type_id: xml.css("transaction > paymentMethod > type").text,
            code: xml.css("transaction > paymentMethod > code").text
          }

          data[:payment_link] = xml.css("transaction > paymentLink").text
          data[:gross_amount] = BigDecimal(xml.css("transaction > grossAmount").text)
          data[:discount_amount] = BigDecimal(xml.css("transaction > discountAmount").text)
          data[:fee_amount] = BigDecimal(xml.css("transaction > feeAmount").text)
          data[:net_amount] = BigDecimal(xml.css("transaction > netAmount").text)
          data[:extra_amount] = BigDecimal(xml.css("transaction > extraAmount").text)
          data[:installments] = xml.css("transaction > installmentCount").text.to_i

          serialize_items(data)
          serialize_sender(data)
          serialize_shipping(data)
        end
      end

      def serialize_items(data)
        data[:items] = []

        xml.css("transaction > items > item").each do |node|
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
          name: xml.css("transaction > sender > name").text,
          email: xml.css("transaction > sender > email").text
        }

        serialize_phone(sender)
        data[:sender] = sender
      end

      def serialize_phone(data)
        data[:phone] = {
          area_code: xml.css("transaction > sender > phone > areaCode").text,
          number: xml.css("transaction > sender > phone > number").text
        }
      end

      def serialize_shipping(data)
        shipping = {
          type_id: xml.css("transaction > shipping > type").text,
          cost: BigDecimal(xml.css("transaction > shipping > cost").text),
        }

        serialize_address(shipping)
        data[:shipping] = shipping
      end

      def serialize_address(data)
        data[:address] = {
          street: xml.css("transaction > shipping > address > street").text,
          number: xml.css("transaction > shipping > address > number").text,
          complement: xml.css("transaction > shipping > address > complement").text,
          district: xml.css("transaction > shipping > address > district").text,
          city: xml.css("transaction > shipping > address > city").text,
          state: xml.css("transaction > shipping > address > state").text,
          country: xml.css("transaction > shipping > address > country").text,
          postal_code: xml.css("transaction > shipping > address > postalCode").text,
        }
      end

      def xml
        @response.data
      end
    end
  end
end
