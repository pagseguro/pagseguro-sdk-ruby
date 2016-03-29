module PagSeguro
  class Subscription
    class ResponseSerializer
      attr_reader :xml

      def initialize(xml)
        @xml = xml
      end

      def serialize
        {}.tap do |data|
          data[:code] = xml.css('directPreApproval > code').text
        end
      end

      def serialize_from_search
        {}.tap do |data|
          data[:name] = xml.at_css('name').text
          data[:code] = xml.css('code').text
          data[:date] = xml.css('date').text
          data[:tracker] = xml.css('tracker').text
          data[:status] = xml.css('status').text
          data[:reference] = xml.css('reference').text
          data[:last_event_date] = xml.css('lastEventDate').text
          data[:charge] = xml.css('charge').text
          data[:sender] = serialize_sender if xml.at_css('sender')
        end
      end

      private

      def serialize_sender
        {}.tap do |data|
          data[:name] = xml.at_css('sender > name').text
          data[:email] = xml.at_css('sender > email').text
          data[:phone] = serialize_phone if xml.at_css('phone')
          data[:address] = serialize_address if xml.at_css('address')
        end
      end

      def serialize_phone
        {}.tap do |data|
          data[:area_code] = xml.css('sender > phone > areaCode').text
          data[:number] = xml.css('sender > phone > number').text
        end
      end

      def serialize_address
        {}.tap do |data|
          data[:street] = xml.at_css('sender > address > street').text
          data[:number] = xml.at_css('sender > address > number').text
          data[:complement] = xml.at_css('sender > address > complement').text
          data[:district] = xml.at_css('sender > address > district').text
          data[:city] = xml.at_css('sender > address > city').text
          data[:state] = xml.at_css('sender > address > state').text
          data[:country] = xml.at_css('sender > address > country').text
          data[:postal_code] = xml.at_css('sender > address > postalCode').text
        end
      end
    end
  end
end
