module PagSeguro
  class PaymentRequest
    class Serializer
      # The payment request that will be serialized.
      attr_reader :payment_request

      def initialize(payment_request)
        @payment_request = payment_request
      end

      def to_params
        params[:receiverEmail] = PagSeguro.receiver_email
        params[:currency] = payment_request.currency
        params[:reference] = payment_request.reference
        params[:extraAmount] = to_amount(payment_request.extra_amount)
        params[:redirectURL] = payment_request.redirect_url
        params[:notificationURL] = payment_request.notification_url
        params[:abandonURL] = payment_request.abandon_url
        params[:maxUses] = payment_request.max_uses
        params[:maxAge] = payment_request.max_age
        payment_request.items.each.with_index(1) do |item, index|
          serialize_item(item, index)
        end

        serialize_sender(payment_request.sender)
        serialize_shipping(payment_request.shipping)
        serialize_extra_params(payment_request.extra_params)

        params.delete_if {|key, value| value.nil? }

        params
      end

      private
      def params
        @params ||= {}
      end

      def serialize_item(item, index)
        params["itemId#{index}"] = item.id
        params["itemDescription#{index}"] = item.description
        params["itemAmount#{index}"] = to_amount(item.amount)
        params["itemQuantity#{index}"] = item.quantity
        params["itemShippingCost#{index}"] = to_amount(item.shipping_cost)
        params["itemWeight#{index}"] = item.weight if item.weight
      end

      def serialize_sender(sender)
        return unless sender

        params[:senderEmail] =  sender.email
        params[:senderName] = sender.name
        params[:senderCPF] = sender.cpf

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

      def serialize_extra_params(extra_params)
        return unless extra_params

        extra_params.each do |extra_param|
          params[extra_param.keys.first] = extra_param.values.first
        end
      end

      def to_amount(amount)
        "%.2f" % BigDecimal(amount.to_s).round(2).to_s("F") if amount
      end
    end
  end
end
