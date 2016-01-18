module PagSeguro
  class Phones
    extend Forwardable
    include Enumerable
    include Extensions::EnsureType

    def_delegators :@store, :size, :clear, :empty?, :any?, :each

    def initialize
      @store = []
    end

    def << (phone)
      phone = ensure_type(Phone, phone)
      @store << phone unless include?(phone)
    end

    def include?(phone)
      @store.detect do |stored_phone|
        stored_phone.type       == phone.type &&
        stored_phone.number     == phone.number &&
        stored_phone.area_code  == phone.area_code
      end
    end
  end
end
