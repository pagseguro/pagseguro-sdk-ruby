require_relative 'boot'

credentials = PagSeguro::Credentials.new('app4521929942', '1D47384E6565EBE664DAEF9AD690438B')
puts credentials.authorize
