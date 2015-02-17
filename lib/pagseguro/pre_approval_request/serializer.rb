module PagSeguro
  class PreApprovalRequest
    class Serializer
      # The pre_approval_request request that will be serialized.
      attr_reader :pre_approval_request

      def initialize(pre_approval_request)
        @pre_approval_request = pre_approval_request
      end

      def to_params
        params[:receiverEmail] = PagSeguro.receiver_email
        
        params[:preApprovalCharge] = pre_approval_request.charge
        params[:preApprovalName] = pre_approval_request.name
        params[:preApprovalDetails] = pre_approval_request.details
        params[:preApprovalAmountPerPayment] = to_amount(pre_approval_request.amount_per_payment)
        params[:preApprovalPeriod] = pre_approval_request.period
        params[:preApprovalFinalDate] = to_date(pre_approval_request.final_date)
        params[:preApprovalMaxTotalAmount] = to_amount(pre_approval_request.max_total_amount)
        params[:reference] = pre_approval_request.reference
        params[:reviewURL] = pre_approval_request.review_url
        params[:redirectURL] = pre_approval_request.redirect_url
      
        serialize_sender(pre_approval_request.sender)

        params.delete_if {|key, value| value.nil? }

        params
      end

      private
      def params
        @params ||= {}
      end

      def serialize_sender(sender)
        return unless sender

        params[:senderEmail] =  sender.email
        params[:senderName] = sender.name
        params[:senderCPF] = sender.cpf
        
        serialize_phone(sender.phone)
        serialize_address(sender.address)
      end

      def serialize_phone(phone)
        return unless phone

        params[:senderAreaCode] = phone.area_code
        params[:senderPhone] = phone.number
      end

      def serialize_address(address)
        return unless address

        params[:senderAddressCountry] = address.country
        params[:senderAddressState] = address.state
        params[:senderAddressCity] = address.city
        params[:senderAddressPostalCode] = address.postal_code
        params[:senderAddressDistrict] = address.district
        params[:senderAddressStreet] = address.street
        params[:senderAddressNumber] = address.number
        params[:senderAddressComplement] = address.complement
      end

      def to_amount(amount)
        "%.2f" % BigDecimal(amount.to_s).round(2).to_s("F") if amount
      end

      def to_date(date)
        Time.parse(date.to_s).iso8601(1) if date
      end
    end
  end
end
