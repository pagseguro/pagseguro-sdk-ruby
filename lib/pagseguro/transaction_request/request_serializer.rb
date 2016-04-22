module PagSeguro
  class TransactionRequest
    class RequestSerializer
      # The transaction request that will be serialized.
      attr_reader :transaction_request

      def initialize(transaction_request)
        @transaction_request = transaction_request
      end

      def to_xml_params
        xml_builder.to_xml(
          save_with:
          Nokogiri::XML::Node::SaveOptions::NO_EMPTY_TAGS |
          Nokogiri::XML::Node::SaveOptions::FORMAT
        )
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
        params[:senderHash] = sender.hash

        serialize_sender_documents(sender.documents)
        serialize_sender_phone(sender.phone)
      end

      def serialize_sender_documents(documents)
        return if documents.empty?

        documents.each do |document|
          params[:senderCPF] = document.value if document.cpf?
          params[:senderCNPJ] = document.value if document.cnpj?
        end
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

      def xml_builder
        Nokogiri::XML::Builder.new(encoding: PagSeguro.encoding) do |xml|
          xml.send(:payment) {
            xml.mode transaction_request.payment_mode
            xml.method_ transaction_request.payment_method
            xml.currency transaction_request.currency
            xml.notificationURL transaction_request.notification_url
            xml.extraAmount to_amount(transaction_request.extra_amount || 0)
            xml.reference transaction_request.reference

            xml_serialize_sender(xml, transaction_request.sender)
            xml_serialize_items(xml, transaction_request.items)
            xml_serialize_receivers(xml, transaction_request.receivers)
            xml_serialize_shipping(xml, transaction_request.shipping)
            xml_serialize_credit_card(xml)
          }
        end
      end

      def xml_serialize_credit_card(xml)
        return unless transaction_request.is_a?(PagSeguro::CreditCardTransactionRequest)

        xml.send(:creditCard) do
          xml.send(:token, transaction_request.credit_card_token)

          if transaction_request.installment
            xml.send(:installment) do
              xml.send(:quantity, transaction_request.installment.quantity)
              xml.send(:value, to_amount(transaction_request.installment.value))
            end
          end

          if transaction_request.billing_address
            xml.send(:billingAddress) do
              xml.send(:street, transaction_request.billing_address.street)
              xml.send(:number, transaction_request.billing_address.number)
              xml.send(:complement, transaction_request.billing_address.complement)
              xml.send(:district, transaction_request.billing_address.district)
              xml.send(:city, transaction_request.billing_address.city)
              xml.send(:state, transaction_request.billing_address.state)
              xml.send(:country, transaction_request.billing_address.country)
              xml.send(:postalCode, transaction_request.billing_address.postal_code)
            end
          end

          if transaction_request.holder
            xml.send(:holder) do
              xml.send(:name, transaction_request.holder.name)
              xml_serialize_documents(xml, [transaction_request.holder.document])

              xml.send(:birthDate, transaction_request.holder.birth_date)
              xml_serialize_phone(xml, transaction_request.holder.phone)
            end
          end
        end
      end

      def xml_serialize_documents(xml, documents = [])
        documents = documents.reject(&:nil?)

        return if documents.empty?

        xml.send(:documents) {
          documents.each do |document|
            xml.send(:document) {
              xml.send(:type, document.type)
              xml.send(:value, document.value)
            }
          end
        }
      end

      def xml_serialize_phone(xml, phone)
        if phone
          xml.send(:phone) {
            xml.send(:areaCode, phone.area_code)
            xml.send(:number, phone.number)
          }
        end
      end

      def xml_serialize_shipping(xml, shipping)
        return unless shipping

        xml.send(:shipping) do
          if shipping.address
            xml.send(:address) do
              xml.send(:street, shipping.address.street)
              xml.send(:number, shipping.address.number)
              xml.send(:district, shipping.address.district)
              xml.send(:country, shipping.address.country)
              xml.send(:postalCode, shipping.address.postal_code)
              xml.send(:city, shipping.address.city)
              xml.send(:state, shipping.address.state)
              xml.send(:complement, shipping.address.complement)
            end
          end
        end
      end

      def xml_serialize_items(xml, items)
        return unless items

        xml.send(:items) do
          items.each do |item|
            xml.send(:item) do
              xml.send(:id, item.id)
              xml.send(:description, item.description)
              xml.send(:quantity, item.quantity)
              xml.send(:amount, to_amount(item.amount))
            end
          end
        end
      end

      def xml_serialize_sender(xml, sender)
        return unless sender

        xml.send(:sender) {
          xml.send(:name, sender.name)
          xml.send(:email, sender.email)

          xml_serialize_phone(xml, sender.phone)
          xml_serialize_documents(xml, sender.documents)

          xml.send(:hash_, sender.hash)
        }
      end

      def xml_serialize_receivers(xml, receivers)
        return if receivers.empty?

        xml.send(:receivers) {
          receivers.each do |receiver|
            xml.send(:receiver) {
              xml.send(:publicKey, receiver.public_key)
              xml.send(:split) {
                xml.send(:amount, to_amount(receiver.split.amount))
                xml.send(:ratePercent, to_amount(receiver.split.rate_percent))
                xml.send(:feePercent, to_amount(receiver.split.fee_percent))
              }
            }
          end
        }
      end
    end
  end
end
