module PagSeguro
  class Session
    class Response
      extend Forwardable

      def_delegators :response, :success?

      # The request response.
      attr_reader :response

      def initialize(response)
        @response = response
      end

      def errors
        @errors ||= Errors.new(response)
      end

      def parse
        serialize_and_create_attributes!
        self
      end

      private
      def serialize_and_create_attributes!
        if response.success? and response.xml?
          create_attributes(serialize)
        end
      end

      def serialize
        xml = Nokogiri::XML(response.body).css("session").first
        Serializer.new(xml).serialize
      end

      def create_attributes(data)
        data.each do |attr_name, attr_value|
          self.class.send(:attr_reader, attr_name)
          instance_variable_set("@#{attr_name}", attr_value)
        end
      end
    end
  end
end
