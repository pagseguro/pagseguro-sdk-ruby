VCR.configure do |config|
  config.hook_into :webmock
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.before_record do |i|
    i.response.body.force_encoding('UTF-8')
  end
end
