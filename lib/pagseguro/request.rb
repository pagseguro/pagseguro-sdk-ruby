module PagSeguro
  Request = Aitch::Namespace.new

  Request.configure do |config|
    config.default_headers = {
      "lib-description"             => "ruby:#{PagSeguro::VERSION}",
      "language-engine-description" => "ruby:#{RUBY_VERSION}"
    }
  end
end
