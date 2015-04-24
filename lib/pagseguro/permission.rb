module PagSeguro
  class Permission
    include Extensions::MassAssignment
    # The permission code
    attr_accessor :code

    # The permission status
    attr_accessor :status

    # The time when the permission was last updated
    attr_accessor :last_update
  end
end
