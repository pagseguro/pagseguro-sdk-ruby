module PagSeguro
  class SubscriptionPlan
    class RequestSerializer
      attr_reader :object

      def initialize(object)
        @object = object
      end

      def to_xml_params
        xml_builder.to_xml(
          save_with:
          Nokogiri::XML::Node::SaveOptions::NO_EMPTY_TAGS |
          Nokogiri::XML::Node::SaveOptions::FORMAT
        )
      end

      private

      def to_amount(amount)
        "%.2f" % BigDecimal(amount.to_s.to_f.to_s).round(2).to_s("F") if amount
      end

      def xml_serialize_sender(xml)
        return unless object.sender

        xml.send(:sender) {
          xml.send(:name, object.sender.name)
          xml.send(:email, object.sender.email)
          if object.sender.phone
            xml.send(:phone) {
              xml.send(:areaCode, object.sender.phone.area_code)
              xml.send(:number, object.sender.phone.number)
            }
          end

          if object.sender.address
            xml.send(:address) {
              xml.send(:street, object.sender.address.street)
              xml.send(:number, object.sender.address.number)
              xml.send(:complement, object.sender.address.complement)
              xml.send(:district, object.sender.address.district)
              xml.send(:postalCode, object.sender.address.postal_code)
              xml.send(:city, object.sender.address.city)
              xml.send(:state, object.sender.address.state)
              xml.send(:country, object.sender.address.country)
            }
          end
        }
      end

      def xml_builder
        Nokogiri::XML::Builder.new(encoding: PagSeguro.encoding) do |xml|
          xml.send(:preApprovalRequest) {
            xml.send(:redirectURL, object.redirect_url)
            xml.send(:reviewURL, object.review_url)
            xml.send(:reference, object.reference)
            xml.send(:maxUsers, object.max_users)
            xml_serialize_sender(xml)

            xml.send(:preApproval) {
              xml.send(:name, object.name)
              xml.send(:details, object.details)
              xml.send(:charge, object.charge)
              xml.send(:period, object.period)
              xml.send(:amountPerPayment, to_amount(object.amount))
              xml.send(:maxTotalAmount, to_amount(object.max_total_amount))
              xml.send(:maxPaymentsPerPeriod, object.max_payments_per_period.to_i) if object.max_payments_per_period
              xml.send(:maxAmountPerPeriod, to_amount(object.max_amount_per_period))
              xml.send(:maxAmountPerPayment, to_amount(object.max_amount_per_payment))
              xml.send(:finalDate, object.final_date.xmlschema) if object.final_date
              xml.send(:initialDate, object.initial_date.xmlschema) if object.initial_date
              xml.send(:membershipFee, to_amount(object.membership_fee))
              xml.send(:trialPeriodDuration, object.trial_duration.to_i) if object.trial_duration.present?
            }
          }
        end
      end
    end
  end
end
