# coding: utf-8
require "./lib/pagseguro/version"

Gem::Specification.new do |spec|
  spec.name          = "pagseguro"
  spec.version       = PagSeguro::VERSION
  spec.authors       = ["Nando Vieira"]
  spec.email         = ["fnando.vieira@gmail.com"]
  spec.description   = ""
  spec.summary       = ""
  spec.homepage      = "http://pagseguro.com.br"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "aitch"
  spec.add_dependency "nokogiri"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry-meta"
  spec.add_development_dependency "autotest-standalone"
  spec.add_development_dependency "test_notifier"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "fakeweb"
end
