module PagSeguro
  class PaymentRequest
    class Serializer
      # The payment request that will be serialized.
      attr_reader :payment_request

      def initialize(payment_request)
        @payment_request = payment_request
      end

      def to_params
        params[:charset] = PagSeguro.encoding
        params[:email] = PagSeguro.email
        params[:receiverEmail] = PagSeguro.receiver_email
        params[:token] = PagSeguro.token
        params[:currency] = payment_request.currency
        params[:reference] = payment_request.reference
        params[:extraAmount] = to_amount(payment_request.extra_amount)
        params[:redirectURL] = payment_request.redirect_url
        params[:notificationURL] = payment_request.notification_url
        params[:maxUses] = payment_request.max_uses
        params[:maxAge] = payment_request.max_age
        payment_request.items.each.with_index(1, &method(:serialize_item))

        serialize_sender(payment_request.sender)
        serialize_shipping(payment_request.shipping)

        params.delete_if {|key, value| value.nil? }

        params
      end

      private
      def params
        @params ||= {}
      end

      def serialize_item(item, index)
        params["ItemId#{index}"] = item.id
        params["ItemDescription#{index}"] = item.description
        params["ItemAmount#{index}"] = to_amount(item.amount)
        params["ItemQuantity#{index}"] = item.quantity
        params["ItemShippingCost#{index}"] = to_amount(item.shipping_cost)
        params["ItemWeight#{index}"] = item.weight if item.weight
      end

      def serialize_sender(sender)
        return unless sender

        params[:senderEmail] =  sender.email
        params[:senderName] = sender.name

        serialize_phone(sender.phone)
      end

      def serialize_phone(phone)
        return unless phone

        params[:senderAreaCode] = phone.area_code
        params[:senderPhone] = phone.number
      end

      def serialize_shipping(shipping)
        return unless shipping

        params[:shippingType] = shipping.type_id
        params[:shippingCost] = to_amount(shipping.cost)

        serialize_address(shipping.address)
      end

      def serialize_address(address)
        return unless address

        params[:shippingAddressCountry] = address.country
        params[:shippingAddressState] = address.state
        params[:shippingAddressCity] = address.city
        params[:shippingAddressPostalCode] = address.postal_code
        params[:shippingAddressDistrict] = address.district
        params[:shippingAddressStreet] = address.street
        params[:shippingAddressNumber] = address.number
        params[:shippingAddressComplement] = address.complement
      end

      def to_amount(amount)
        BigDecimal(amount.to_s).round(2).to_s("F") if amount
      end
    end
  end
end
