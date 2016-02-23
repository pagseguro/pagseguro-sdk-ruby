module PagSeguro
  class PaymentRequest
    class RequestSerializer
      # The payment request that will be serialized.
      attr_reader :payment_request

      def initialize(payment_request)
        @payment_request = payment_request
      end

      def to_xml_params
        xml_builder.to_xml(
          save_with:
          Nokogiri::XML::Node::SaveOptions::NO_EMPTY_TAGS |
          Nokogiri::XML::Node::SaveOptions::FORMAT
        )
      end

      def to_params
        {}.tap do |data|
          data[:receiverEmail] = PagSeguro.receiver_email
          data[:currency] = payment_request.currency
          data[:reference] = payment_request.reference
          data[:extraAmount] = to_amount(payment_request.extra_amount)
          data[:redirectURL] = payment_request.redirect_url
          data[:notificationURL] = payment_request.notification_url
          data[:abandonURL] = payment_request.abandon_url
          data[:maxUses] = payment_request.max_uses
          data[:maxAge] = payment_request.max_age
          data[:credentials] = payment_request.credentials
          payment_request.items.each_with_index do |item, index|
            serialize_item(data, item, index.succ)
          end

          serialize_sender(data, payment_request.sender)
          serialize_shipping(data, payment_request.shipping)
          serialize_receivers(data, payment_request.receivers)
          serialize_extra_params(data, payment_request.extra_params)
        end.delete_if { |_, value| value.nil? }
      end

      private

      def serialize_receivers(data, receivers)
        receivers.each.with_index(1) do |receiver, idx|
          data["receiver[#{idx}].email"] = receiver.email
          serialize_receiver_split(data, receiver, idx, receiver.split)
        end
      end

      def serialize_receiver_split(data, receiver, idx, split)
        data["receiver[#{idx}].split.amount"] = receiver.split.amount
        data["receiver[#{idx}].split.feePercent"] = receiver.split.fee_percent
        data["receiver[#{idx}].split.ratePercent"] = receiver.split.rate_percent
      end

      def serialize_item(data, item, index)
        data["itemId#{index}"] = item.id
        data["itemDescription#{index}"] = item.description
        data["itemAmount#{index}"] = to_amount(item.amount)
        data["itemQuantity#{index}"] = item.quantity
        data["itemShippingCost#{index}"] = to_amount(item.shipping_cost)
        data["itemWeight#{index}"] = item.weight if item.weight
      end

      def serialize_sender(data, sender)
        return unless sender

        data[:senderEmail] =  sender.email
        data[:senderName] = sender.name
        data[:senderCPF] = sender.cpf

        serialize_phone(data, sender.phone)
      end

      def serialize_phone(data, phone)
        return unless phone

        data[:senderAreaCode] = phone.area_code
        data[:senderPhone] = phone.number
      end

      def serialize_shipping(data, shipping)
        return unless shipping

        data[:shippingType] = shipping.type_id
        data[:shippingCost] = to_amount(shipping.cost)

        serialize_address(data, shipping.address)
      end

      def serialize_address(data, address)
        return unless address

        data[:shippingAddressCountry] = address.country
        data[:shippingAddressState] = address.state
        data[:shippingAddressCity] = address.city
        data[:shippingAddressPostalCode] = address.postal_code
        data[:shippingAddressDistrict] = address.district
        data[:shippingAddressStreet] = address.street
        data[:shippingAddressNumber] = address.number
        data[:shippingAddressComplement] = address.complement
      end

      def serialize_extra_params(data, extra_params)
        return unless extra_params

        extra_params.each do |extra_param|
          data[extra_param.keys.first] = extra_param.values.first
        end
      end

      def to_amount(amount)
        "%.2f" % BigDecimal(amount.to_s).round(2).to_s("F") if amount
      end

      def xml_builder
        Nokogiri::XML::Builder.new(encoding: PagSeguro.encoding) do |xml|
          xml.send(:checkout) {
            xml_serialize_receivers(xml)
            xml_serialize_sender(xml, payment_request.sender)
            xml.send(:currency, payment_request.currency)
            xml.send(:reference, payment_request.reference)
            xml.send(:redirectURL, payment_request.redirect_url)
            xml.send(:notificationURL, payment_request.notification_url)
            xml_serialize_items(xml, payment_request.items)
          }
        end
      end

      def xml_serialize_items(xml, items)
        xml.send(:items) {
          items.each do |item|
            xml.send(:item) {
              xml.send(:id, item.id)
              xml.send(:description, item.description)
              xml.send(:quantity, item.quantity)
              xml.send(:amount, to_amount(item.amount))
              xml.send(:weight, item.weight) if item.weight
              xml.send(:shippingCost, to_amount(item.shipping_cost))
            }
          end
        }
      end

      def xml_serialize_sender(xml, sender)
        return unless sender

        xml.send(:sender) {
          xml.send(:name, sender.name)
          xml.send(:email, sender.email)
          if sender.phone
            xml.send(:phone) {
              xml.send(:areaCode, sender.phone.area_code)
              xml.send(:number, sender.phone.number)
            }
          end
        }
      end

      def xml_serialize_receivers(xml)
        xml.send(:primaryReceiver) {
          xml.send(:email, payment_request.primary_receiver)
        }

        xml.send(:receivers) {
          payment_request.receivers.each do |receiver|
            xml.send(:receiver) {
              xml.send(:email, receiver.email)
              xml.send(:split) {
                xml.send(:amount, receiver.split.amount)
              }
            }
          end
        }
      end
    end
  end
end
