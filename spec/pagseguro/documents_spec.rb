require 'spec_helper'

describe PagSeguro::Documents do
  it "implements #each" do
    expect(PagSeguro::Documents.new).to respond_to(:each)
  end

  it "includes Enumerable" do
    expect(PagSeguro::Documents.included_modules).to include(Enumerable)
  end

  it "sets document" do
    document = PagSeguro::Document.new
    documents = PagSeguro::Documents.new
    documents << document

    expect(documents.size).to eql(1)
    expect(documents).to include(document)
  end

  it "sets document releases from Hash" do
    document = PagSeguro::Document.new(value: 1234)

    expect(PagSeguro::Document).to(
      receive(:new)
      .with({value: 1234})
      .and_return(document))

    documents = PagSeguro::Documents.new
    documents << {value: 1234}

    expect(documents).to include(document)
  end
end
