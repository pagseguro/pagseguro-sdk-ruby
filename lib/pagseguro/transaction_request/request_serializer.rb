module PagSeguro
  class TransactionRequest
    class RequestSerializer
      # The transaction request that will be serialized.
      attr_reader :transaction_request

      def initialize(transaction_request)
        @transaction_request = transaction_request
      end

      def to_params
        params[:receiverEmail] = PagSeguro.receiver_email
        params[:currency] = transaction_request.currency
        params[:reference] = transaction_request.reference
        params[:extraAmount] = to_amount(transaction_request.extra_amount)
        params[:notificationURL] = transaction_request.notification_url
        params[:paymentMethod] = transaction_request.payment_method
        params[:paymentMode] = transaction_request.payment_mode
        params[:creditCardToken] = transaction_request.credit_card_token if transaction_request.respond_to?(:credit_card_token)
        transaction_request.items.each.with_index(1) do |item, index|
          serialize_item(item, index)
        end

        serialize_sender(transaction_request.sender)
        serialize_shipping(transaction_request.shipping)
        serialize_extra_params(transaction_request.extra_params)

        serialize_bank(transaction_request.bank) if transaction_request.respond_to?(:bank)
        serialize_holder(transaction_request.holder) if transaction_request.respond_to?(:holder)
        serialize_billing_address(transaction_request.billing_address) if transaction_request.respond_to?(:billing_address)
        serialize_installment(transaction_request.installment) if transaction_request.respond_to?(:installment)

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

      def serialize_bank(bank)
        return unless bank

        params[:bankName] = bank.name
      end

      def serialize_holder(holder)
        return unless holder

        params[:creditCardHolderName] = holder.name
        params[:creditCardHolderBirthDate] = holder.birth_date
        params[:creditCardHolderCPF] = holder.document.value

        serialize_holder_phone(holder.phone)
      end

      def serialize_holder_phone(phone)
        return unless phone

        params[:creditCardHolderAreaCode] = phone.area_code
        params[:creditCardHolderPhone] = phone.number
      end

      def serialize_billing_address(address)
        return unless address

        params[:billingAddressCountry] = address.country
        params[:billingAddressState] = address.state
        params[:billingAddressCity] = address.city
        params[:billingAddressPostalCode] = address.postal_code
        params[:billingAddressDistrict] = address.district
        params[:billingAddressStreet] = address.street
        params[:billingAddressNumber] = address.number
        params[:billingAddressComplement] = address.complement
      end

      def serialize_sender(sender)
        return unless sender

        params[:senderEmail] =  sender.email
        params[:senderName] = sender.name
        params[:senderCPF] = sender.cpf
        params[:senderHash] = sender.hash

        serialize_sender_phone(sender.phone)
      end

      def serialize_sender_phone(phone)
        return unless phone

        params[:senderAreaCode] = phone.area_code
        params[:senderPhone] = phone.number
      end

      def serialize_shipping(shipping)
        return unless shipping

        params[:shippingType] = shipping.type_id
        params[:shippingCost] = to_amount(shipping.cost)

        serialize_shipping_address(shipping.address)
      end

      def serialize_shipping_address(address)
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

      def serialize_installment(installment)
        return unless installment

        params[:installmentValue] = to_amount(installment.value)
        params[:installmentQuantity] = installment.quantity
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
