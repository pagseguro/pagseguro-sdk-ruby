# coding: utf-8
require "./lib/pagseguro/version"

Gem::Specification.new do |spec|
  spec.required_ruby_version = ">= 1.9.3"
  spec.name                  = "pagseguro-oficial"
  spec.version               = PagSeguro::VERSION
  spec.authors               = ["Nando Vieira"]
  spec.email                 = ["fnando.vieira@gmail.com"]
  spec.description           = "Biblioteca oficial de integração PagSeguro em Ruby"
  spec.summary               = spec.description
  spec.homepage              = "http://www.pagseguro.com.br"
  spec.license               = "ASL"

  spec.files                 = `git ls-files`.split($/)
  spec.executables           = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files            = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths         = ["lib"]

  spec.add_dependency "aitch", ">= 0.2.1"
  spec.add_dependency "nokogiri"
  spec.add_dependency "i18n"
  spec.add_dependency "json"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "autotest-standalone"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "fakeweb"
end
