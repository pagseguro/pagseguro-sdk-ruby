module PagSeguro
  class Refund
    class Response
      def initialize(response, refund)
        @response = response
        @refund = refund
      end

      def serialize
        if success?
          xml = Nokogiri::XML(response.body)
          serialize = ResponseSerializer.new(xml).serialize
          refund.update_attributes(serialize)
        else
          refund.errors.add(response)
        end

        refund
      end

      def success?
        response.success? && response.xml?
      end

      private
      # The request response.
      attr_reader :response

      # The refund object to return
      attr_reader :refund
    end
  end
end
