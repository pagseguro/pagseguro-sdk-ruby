module PagSeguro
  class PreApproval
    class Serializer
      attr_reader :xml

      def initialize(xml)
        @xml = xml
      end

      def serialize
        {}.tap do |data|
          serialize_general(data)
          serialize_dates(data)
          serialize_sender(data)
        end
      end


      def serialize_general(data)
        data[:name] = xml.css(">name").text
        data[:code] = xml.css(">code").text
        data[:date] = Time.parse(xml.css("date").text)
        data[:tracker] = xml.css(">tracker").text
        data[:status] = xml.css(">status").text
        data[:reference] = xml.css(">reference").text
        data[:last_event_date] = Time.parse(xml.css("lastEventDate").text)
        data[:charge] = xml.css(">charge").text

      end

      def serialize_dates(data)
      end

      def serialize_sender(data)
        sender = {
          name: xml.css("sender > name").text,
          email: xml.css("sender > email").text
        }

        serialize_phone(sender)
        serialize_address(sender)
        data[:sender] = sender
      end

      def serialize_phone(data)
        data[:phone] = {
          area_code: xml.css("sender > phone > areaCode").text,
          number: xml.css("sender > phone > number").text
        }
      end


      def serialize_address(data)
        data[:address] = {
          street: address_node.css("> street").text,
          number: address_node.css("> number").text,
          complement: address_node.css("> complement").text,
          district: address_node.css("> district").text,
          city: address_node.css("> city").text,
          state: address_node.css("> state").text,
          country: address_node.css("> country").text,
          postal_code: address_node.css("> postalCode").text,
        }
      end

      def address_node
        @address_node ||= xml.css("sender > address")
      end

    end
  end
end