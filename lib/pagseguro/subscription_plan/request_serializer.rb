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

      def xml_builder
        Nokogiri::XML::Builder.new(encoding: PagSeguro.encoding) do |xml|
          xml.send(:preApprovalRequest) {
            xml.send(:maxUsers, object.max_users)
            xml.send(:preApproval) {
              xml.send(:name, object.name)
              xml.send(:charge, object.charge)
              xml.send(:period, object.period)
              xml.send(:amountPerPayment, to_amount(object.amount))
              xml.send(:maxTotalAmount, to_amount(object.max_amount))
              xml.send(:finalDate, object.final_date.to_s + 'T00:00:000-03:00') if object.final_date
              xml.send(:membershipFee, to_amount(object.membership_fee))
              xml.send(:trialPeriodDuration, object.trial_duration.to_i)
            }
          }
        end
      end
    end
  end
end
