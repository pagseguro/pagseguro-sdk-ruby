require "spec_helper"

describe PagSeguro::Document do
  it_assigns_attribute :type
  it_assigns_attribute :value

  it '==' do
    document = PagSeguro::Document.new(type: 'TYPE', value: 'VALUE')
    expect(document).to eq PagSeguro::Document.new(type: 'TYPE', value: 'VALUE')
  end

  context 'helpers' do
    it 'cpf?' do
      expect{ subject.type = 'CPF' }.to change{ subject.cpf? }.to true
    end

    it 'cnpj?' do
      expect{ subject.type = 'CNPJ' }.to change{ subject.cnpj? }.to true
    end
  end
end
