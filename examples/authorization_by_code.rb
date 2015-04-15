require_relative 'boot'

options = {
  credentials: PagSeguro::Credentials.new('app452', '1D47384')
}

permissions = PagSeguro::Authorization.find_by_code(options, 'authorization_code')
