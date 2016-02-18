# coding: utf-8
require "./lib/pagseguro/version"

Gem::Specification.new do |spec|
  spec.name                  = "pagseguro-oficial"
  spec.version               = PagSeguro::VERSION
  spec.authors               = ["Nando Vieira"]
  spec.email                 = ["fnando.vieira@gmail.com"]
  spec.summary               = "Biblioteca de integração com o PagSeguro"
  spec.description           = "Biblioteca oficial de integração via API com o PagSeguro"
  spec.homepage              = "http://www.pagseguro.com.br"
  spec.license               = "ASL"

  spec.files                 = `git ls-files`.split($/)
  spec.executables           = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files            = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths         = ["lib"]

  spec.required_ruby_version = ">= 1.9.3"

  spec.add_runtime_dependency "aitch", "~> 0.2"
  spec.add_runtime_dependency "nokogiri", "~> 1.6"
  spec.add_runtime_dependency "i18n", "~> 0.7"
  spec.add_runtime_dependency "json", "~> 1.8"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "fakeweb", "~> 1.3"
  spec.add_development_dependency "activesupport", "~> 4.0"
end
