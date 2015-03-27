module Helpers
  def xml_response(path)
    response = double(
      body: File.read("./spec/fixtures/#{path}"),
      code: 200,
      content_type: "text/xml",
      "[]" => nil
    )

    Aitch::Response.new({xml_parser: Aitch::XMLParser}, response)
  end
end

RSpec.configure {|c| c.include(Helpers) }
