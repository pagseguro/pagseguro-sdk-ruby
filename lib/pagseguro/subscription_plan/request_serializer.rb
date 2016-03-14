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
        "%.2f" % BigDecimal(amount.to_s).round(2).to_s("F") if amount
      end

      def sender
        object.sender
      end

      def address
        object.sender_address
      end

      def xml_serialize_sender(xml)
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

          if address
            xml.send(:address) {
              xml.send(:street, address.street)
              xml.send(:number, address.number)
              xml.send(:complement, address.complement)
              xml.send(:district, address.district)
              xml.send(:postalCode, address.postal_code)
              xml.send(:city, address.city)
              xml.send(:state, address.state)
              xml.send(:country, address.country)
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
              xml.send(:maxTotalAmount, to_amount(object.max_amount))
              xml.send(:maxAmountPerPeriod, to_amount(object.max_amount_per_period))
              xml.send(:finalDate, object.final_date.xmlschema) if object.final_date
              xml.send(:membershipFee, to_amount(object.membership_fee))
              xml.send(:trialPeriodDuration, object.trial_duration.to_i)
            }
          }
        end
      end
    end
  end
end
