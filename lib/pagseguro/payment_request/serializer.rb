module PagSeguro
  class PaymentRequest
    class Serializer
      # The payment request that will be serialized.
      attr_reader :payment_request

      def initialize(payment_request)
        @payment_request = payment_request
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
          payment_request.items.each_with_index do |item, index|
            serialize_item(data, item, index.succ)
          end

          serialize_sender(data, payment_request.sender)
          serialize_shipping(data, payment_request.shipping)
          serialize_extra_params(data, payment_request.extra_params)
        end.delete_if { |_, value| value.nil? }
      end

      private
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
    end
  end
end
