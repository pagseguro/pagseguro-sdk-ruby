module PagSeguro
  class ManualSubscriptionCharger
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

      def to_amount(amount = 0.0)
        "%.2f" % BigDecimal(amount.to_s).round(2).to_s("F")
      end

      def xml_serialize_items(xml, items = [])
        return if items.empty?

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

      def xml_builder
        Nokogiri::XML::Builder.new(encoding: PagSeguro.encoding) do |xml|
          xml.send(:payment) {
            xml.send(:reference, object.reference)
            xml.send(:preApprovalCode, object.subscription_code)
            xml_serialize_items(xml, object.items)
          }
        end
      end
    end
  end
end
