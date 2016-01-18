module PagSeguro
  class AuthorizationRequest
    class RequestSerializer

      attr_accessor :request

      def initialize(request)
        @request = request
        @builder = Nokogiri::XML::Builder
      end

      def build_xml
        build.to_xml(save_with:
          Nokogiri::XML::Node::SaveOptions::NO_EMPTY_TAGS |
          Nokogiri::XML::Node::SaveOptions::FORMAT
        )
      end

      private

      attr_reader :builder

      def build
        builder.new(encoding: PagSeguro.encoding) do |xml|
          xml.send(:authorizationRequest) {
            xml.send(:reference, request.reference) if request.reference
            xml.send(:redirectURL, request.redirect_url)
            xml.send(:notificationURL, request.notification_url)
            serialize_permissions(xml, request.permissions)
            serialize_account(xml, request.account)
          }
        end
      end

      def serialize_permissions(xml, permissions)
        return unless permissions.any?
        xml.send(:permissions) {
          format_permissions(permissions).each do |permission|
            xml.send(:code, permission)
          end
        }
      end

      def format_permissions(permissions)
        permissions.map { |value| PagSeguro::AuthorizationRequest::PERMISSIONS[value] }
      end

      def serialize_account(xml, account)
        return unless account

        xml.send(:account) {
          xml.send(:email, account.email) if account.email
          xml.send(:type, account.type) if account.type

          if account.person
            serialize_person(xml, account.person)
          elsif account.company
            serialize_company(xml, account.company)
          end
        }
      end

      def serialize_person(xml, person)
        return unless person

        xml.send(:person) {
          xml.send(:name, person.name) if person.name
          xml.send(:birthDate, person.birth_date.to_s) if person.birth_date
          serialize_address(xml, person.address)
          serialize_documents(xml, person.documents)
          serialize_phones(xml, person.phones)
        }
      end

      def serialize_company(xml, company)
        return unless company

        xml.send(:company) {
          xml.send(:name, company.name) if company.name
          xml.send(:displayName, company.display_name) if company.display_name
          xml.send(:websiteURL, company.website_url) if company.website_url
          serialize_partner(xml, company.partner)
          serialize_phones(xml, company.phones)
          serialize_documents(xml, company.documents)
          serialize_address(xml, company.address)
        }
      end

      def serialize_address(xml, address)
        return unless address

        xml.send(:address) {
          xml.send(:postalCode, address.postal_code) if address.postal_code
          xml.send(:street, address.street) if address.street
          xml.send(:number, address.number) if address.number
          xml.send(:complement, address.complement) if address.complement
          xml.send(:district, address.district) if address.district
          xml.send(:city, address.city) if address.city
          xml.send(:state, address.state) if address.state
          xml.send(:country, address.country) if address.country
        }
      end

      def serialize_phones(xml, phones)
        return unless phones.any?

        xml.send(:phones) {
          phones.each do |phone|
            xml.send(:phone) {
              xml.send(:type, phone.type)
              xml.send(:areaCode, phone.area_code)
              xml.send(:number, phone.number)
            }
          end
        }
      end

      def serialize_documents(xml, documents)
        return unless documents.any?

        xml.send(:documents) {
          documents.each do |document|
            xml.send(:document) {
              xml.send(:type, document.type)
              xml.send(:value, document.value)
            }
          end
        }
      end

      def serialize_partner(xml, partner)
        return unless partner

        xml.send(:partner) {
          xml.send(:name, partner.name) if partner.name
          xml.send(:birthDate, partner.birth_date.to_s) if partner.birth_date
          serialize_documents(xml, partner.documents)
        }
      end
    end
  end
end
