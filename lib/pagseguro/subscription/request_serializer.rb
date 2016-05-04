module PagSeguro
  class Subscription
    class RequestSerializer
      # Get the object
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
            xml.send(:plan, object.plan) if object.plan
            xml.send(:reference, object.reference) if object.reference
            serialize_sender(xml, object.sender)
            serialize_payment_method(xml, object.payment_method)
          }
        end
      end

      def serialize_sender(xml, sender)
        return unless sender

        xml.send(:sender) {
          xml.send(:name, sender.name) if sender.name
          xml.send(:email, sender.email) if sender.email
          xml.send(:ip, sender.ip) if sender.ip
          xml.send(:hash_, sender.hash) if sender.hash

          serialize_phone(xml, sender.phone)
          serialize_address(xml, sender.address)
          serialize_documents(xml, sender.documents)
        }
      end

      def serialize_phone(xml, phone)
        return unless phone

        xml.send(:phone) {
          xml.send(:areaCode, phone.area_code)
          xml.send(:number, phone.number)
        }
      end

      def serialize_address(xml, address)
        return unless address

        xml.send(:address) {
          xml.send(:street, address.street) if address.street
          xml.send(:number, address.number) if address.number
          xml.send(:complement, address.complement) if address.complement
          xml.send(:district, address.district) if address.district
          xml.send(:city, address.city) if address.city
          xml.send(:state, address.state) if address.state
          xml.send(:country, address.country) if address.country
          xml.send(:postalCode, address.postal_code) if address.postal_code
        }
      end

      def serialize_billing_address(xml, address)
        return unless address

        xml.send(:billingAddress) {
          xml.send(:street, address.street) if address.street
          xml.send(:number, address.number) if address.number
          xml.send(:complement, address.complement) if address.complement
          xml.send(:district, address.district) if address.district
          xml.send(:city, address.city) if address.city
          xml.send(:state, address.state) if address.state
          xml.send(:country, address.country) if address.country
          xml.send(:postalCode, address.postal_code) if address.postal_code
        }
      end

      def serialize_documents(xml, documents)
        return if documents.empty?

        xml.send(:documents) {
          documents.each do |document|
            serialize_document(xml, document)
          end
        }
      end

      def serialize_document(xml, document)
        return unless document

        xml.send(:document) {
          xml.send(:type, document.type)
          xml.send(:value, document.value)
        }
      end

      def serialize_payment_method(xml, payment_method)
        return unless payment_method

        xml.send(:paymentMethod) {
          xml.send(:type, payment_method.type)
          xml.send(:creditCard) {
            xml.send(:token, payment_method.token)
            serialize_holder(xml, payment_method.holder)
          }
        }
      end

      def serialize_holder(xml, holder)
        return unless holder

        xml.send(:holder) {
          xml.send(:name, holder.name) if holder.name
          xml.send(:birthDate, holder.birth_date) if holder.birth_date
          serialize_document(xml, holder.document)
          serialize_billing_address(xml, holder.billing_address)
          serialize_phone(xml, holder.phone)
        }
      end
    end
  end
end
