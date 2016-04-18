module PagSeguro
  class SubscriptionChangePayment
    class RequestSerializer
      extend Forwardable

      def_delegators :object, :subscription_payment_method
      def_delegators :subscription_payment_method, :holder
      def_delegators :holder, :billing_address

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
          xml.send(:paymentMethod) {
            xml.send(:type, 'CREDITCARD')

            if object.sender
              xml.send(:sender) {
                xml.send(:hash_, object.sender.hash)
                xml.send(:ip, object.sender.ip)
              }
            end

            if object.subscription_payment_method
              xml.send(:creditCard) {
                xml.send(:token, subscription_payment_method.token)
                if holder
                  xml.send(:holder) {
                    xml.send(:name, holder.name)
                    xml.send(:birthDate, holder.birth_date.strftime("%d/%m/%Y"))

                    if holder.phone
                      xml.send(:phone) {
                        xml.send(:areaCode, holder.phone.area_code)
                        xml.send(:number, holder.phone.number)
                      }
                    end

                    if holder.document
                      xml.send(:document) {
                        xml.send(:type, holder.document.type)
                        xml.send(:value, holder.document.value)
                      }
                    end

                    if billing_address
                      xml.send(:billingAddress) {
                        xml.send(:street, billing_address.street)
                        xml.send(:number, billing_address.number)
                        xml.send(:complement, billing_address.complement)
                        xml.send(:district, billing_address.district)
                        xml.send(:city, billing_address.city)
                        xml.send(:state, billing_address.state)
                        xml.send(:country, billing_address.country)
                        xml.send(:postalCode, billing_address.postal_code)
                      }
                    end
                  }
                end
              }
            end
          }
        end
      end
    end
  end
end
