module PagSeguro
  class SubscriptionChangeStatus
    class RequestSerializer
      attr_reader :object

      def initialize(object)
        @object = object
      end

      def serialize
        build.to_xml(save_with:
          Nokogiri::XML::Node::SaveOptions::NO_EMPTY_TAGS |
          Nokogiri::XML::Node::SaveOptions::FORMAT
        )
      end

      private

      def build
        Nokogiri::XML::Builder.new(encoding: PagSeguro.encoding) do |xml|
          xml.send(:directPreApproval) {
            xml.send(:status, object.status_text)
          }
        end
      end
    end
  end
end
