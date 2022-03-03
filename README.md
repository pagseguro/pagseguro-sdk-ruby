`DEPRECATED` # Biblioteca de integração PagSeguro em Ruby

> **_NOTE:_** **Esse SDK foi descontinuado** <br> Estamos trabalhando em soluções e facilidades para evoluirmos a Plataforma de API’s do PagSeguro. Conheça nossa Plataforma de API’s acessando https://dev.pagseguro.uol.com.br/reference/pagseguro-reference-intro

[![Build Status](https://travis-ci.org/pagseguro/ruby.svg?branch=master)](https://travis-ci.org/pagseguro/ruby)
[![Code Climate](https://codeclimate.com/github/pagseguro/ruby/badges/gpa.svg)](https://codeclimate.com/github/pagseguro/ruby)

## Descrição

A biblioteca PagSeguro em Ruby é um conjunto de classes de domínio que facilitam, para o desenvolvedor Ruby, a utilização das funcionalidades que o PagSeguro oferece na forma de APIs. Com a biblioteca instalada e configurada, você pode facilmente integrar funcionalidades como:

 - [Criar Requisições de Pagamentos]
 - [Consultar Transações por Código]
 - [Consultar Transações por Intervalo de Datas]
 - [Receber Notificações]
 - [Estornar Transações por Código]
 - [Cancelar Transações por Código]

## Requisitos

 - [Ruby] 1.9.3+
 - [Aitch] 0.2.1+


## Instalação

 - Adicione a biblioteca ao seu Gemfile.

```ruby
gem "pagseguro-oficial", "~> 2.5.0"
```

 - Execute o comando `bundle install`.

## Configuração

Para fazer a autenticação, você precisará configurar as credenciais do PagSeguro. Crie o arquivo `config/initializers/pagseguro.rb` com o conteúdo abaixo.

```ruby
PagSeguro.configure do |config|
  config.token       = "seu token"
  config.email       = "seu e-mail"
  config.environment = :production # ou :sandbox. O padrão é production.
  config.encoding    = "UTF-8" # ou ISO-8859-1. O padrão é UTF-8.
end
```

O token de segurança está disponível em sua [conta do PagSeguro](https://pagseguro.uol.com.br/integracao/token-de-seguranca.jhtml).

## Pagamentos (API V2)

Para iniciar uma requisição de pagamento, você precisa instanciar a classe `PagSeguro::PaymentRequest`. Isso normalmente será feito em seu controller de checkout.

```ruby
class CheckoutController < ApplicationController
  def create
    # O modo como você irá armazenar os produtos que estão sendo comprados
    # depende de você. Neste caso, temos um modelo Order que referência os
    # produtos que estão sendo comprados.
    order = Order.find(params[:id])

    payment = PagSeguro::PaymentRequest.new

    # Você também pode fazer o request de pagamento usando credenciais
    # diferentes, como no exemplo abaixo

    payment = PagSeguro::PaymentRequest.new(email: 'abc@email', token: 'token')

    payment.reference = order.id
    payment.notification_url = notifications_url
    payment.redirect_url = processing_url

    order.products.each do |product|
      payment.items << {
        id: product.id,
        description: product.title,
        amount: product.price,
        weight: product.weight
      }
    end

    # Caso você precise passar parâmetros para a api que ainda não foram
    # mapeados na gem, você pode fazer de maneira dinâmica utilizando um
    # simples hash.
    payment.extra_params << { paramName: 'paramValue' }
    payment.extra_params << { senderBirthDate: '07/05/1981' }
    payment.extra_params << { extraAmount: '-15.00' }

    response = payment.register

    # Caso o processo de checkout tenha dado errado, lança uma exceção.
    # Assim, um serviço de rastreamento de exceções ou até mesmo a gem
    # exception_notification poderá notificar sobre o ocorrido.
    #
    # Se estiver tudo certo, redireciona o comprador para o PagSeguro.
    if response.errors.any?
      raise response.errors.join("\n")
    else
      redirect_to response.url
    end
  end
end
```

## Notificações (API V3)

O PagSeguro irá notificar a URL informada no processo de checkout. Isso é feito através do método `PagSeguro::PaymentRequest#notification_url`. Esta URL irá receber o código da notificação e tipo de notificação. Com estas informações, podemos recuperar as informações detalhadas sobre o pagamento.

```ruby
class NotificationsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :create

  def create
    transaction = PagSeguro::Transaction.find_by_notification_code(params[:notificationCode])

    if transaction.errors.empty?
      # Processa a notificação. A melhor maneira de se fazer isso é realizar
      # o processamento em background. Uma boa alternativa para isso é a
      # biblioteca Sidekiq.
    end

    render nothing: true, status: 200
  end
end
```

## Consultas (API V3)

### Transações abandonadas (API V2)

Para quantificar o número de transações abandonadas, você pode solicitar uma lista com histórico dessas transações.

```ruby
report = PagSeguro::Transaction.find_abandoned

while report.next_page?
  report.next_page!
  puts "=> Page #{report.page}"

  abort "=> Errors: #{report.errors.join("\n")}" unless report.valid?

  puts "=> Report was created at: #{report.created_at}"
  puts

  report.transactions.each do |transaction|
    puts "=> Abandoned transaction"
    puts "   created at: #{transaction.created_at}"
    puts "   code: #{transaction.code}"
    puts "   type_id: #{transaction.type_id}"
    puts "   gross amount: #{transaction.gross_amount}"
    puts
  end
end
```

### Histórico de transações

Para facilitar seu controle financeiro e seu estoque, você pode solicitar uma lista com histórico das transações da sua loja.

```ruby
report = PagSeguro::Transaction.find_by_date

while report.next_page?
  report.next_page!
  puts "== Page #{report.page}"
  abort "=> Errors: #{report.errors.join("\n")}" unless report.valid?
  puts "Report created on #{report.created_at}"
  puts

  report.transactions.each do |transaction|
    puts "=> Transaction"
    puts "   created_at: #{transaction.created_at}"
    puts "   code: #{transaction.code}"
    puts "   cancellation_source: #{transaction.cancellation_source}"
    puts "   payment method: #{transaction.payment_method.type}"
    puts "   gross amount: #{transaction.gross_amount}"
    puts "   updated at: #{transaction.updated_at}"
    puts
  end
end
```

### Histórico de status de transações

É possível consultar o histórico de mudanças de status em transações

```ruby
response = PagSeguro::Transaction.find_status_history("transaction_code")

response.each do |status|
  puts "STATUS:"
  puts "  code: #{status.code}"
  puts "  date: #{status.date}"
  puts "  notification_code: #{status.notification_code}"
end
```

### Consultar opções de parcelamento

Você pode consultar as opções de parcelamento para um determinado valor.

```ruby
installments = PagSeguro::Installment.find("100.00")

puts "=> INSTALLMENTS"
puts
installments.each do |installment|
  puts installment.inspect
end

visa_installments = PagSeguro::Installment.find("100.00", "visa")

puts
puts "=> VISA INSTALLMENTS"
puts
visa_installments.each do |installment|
  puts installment.inspect
end
```

## Modelo de aplicações

### Setando autorizações

```ruby
  options = {
    credentials: PagSeguro::ApplicationCredentials.new("app4521929942", "1D47384E6565EBE664DAEF9AD690438B"),
    permissions: [:searches, :notifications],
    notification_url: 'foo.com.br',
    redirect_url: 'bar.com.br'
  }
  response = PagSeguro::Authorization.new(options).authorize
```
Em seguida, acesse o link para confirmar as autorizações
```ruby
  response.url
```

### Estorno de Transações

Você pode estornar pagamentos que as transações estiverem com status: Paga (3), Disponível (4), Em disputa (5).

```ruby
  refund = PagSeguro::TransactionRefund.new
  refund.transaction_code = "D5D5BE444148407891E497B421975599"

  response = refund.register

  if response.errors.any?
    puts response.errors.join("\n")
  else
    puts "=> REFUND RESPONSE"
    puts response.result
  end
```

### Cancelamento de Transações

Você pode cancelar transações que estiverem com status: Aguardando pagamento ou Em análise.

```ruby
  cancellation = PagSeguro::TransactionCancellation.new
  cancellation.transaction_code = "AFB8FCF29496401681257C1ECE3A98FF"

  cancellation.register

  if cancellation.errors.any?
    puts cancellation.errors.join("\n")
  else
    puts "=> CANCELLATION RESPONSE"
    puts cancellation.result
  end
```

## API

### PagSeguro::PaymentRequest (utiliza versão V2)

#### Definindo identificador do pedido

```ruby
payment.reference = "ref1234"
```

#### Definindo informações de entrega

```ruby
payment = PagSeguro::PaymentRequest.new
payment.shipping = {
  type_name: "sedex",
  cost: 20.00,
  address: {
    street: "Av. Brig. Faria Lima",
    number: 1384,
    complement: "5 andar",
    district: "Jardim Paulistano",
    city: "São Paulo",
    state: "SP",
    postal_code: "01452002"
  }
}
```

#### Alternativamente você pode definir uma instância da classe `PagSeguro::Shipping`

```ruby
shipping_options = {
  type_name: "sedex",
  cost: 20.00,
  address: {
    street: "Av. Brig. Faria Lima",
    number: 1384,
    complement: "5 andar",
    district: "Jardim Paulistano",
    city: "São Paulo",
    state: "SP",
    postal_code: "01452002"
  }
}

payment.shipping = PagSeguro::Shipping.new(shipping_options)
```

#### Definindo informações do comprador

```ruby
payment.sender = {
  name: "John Doe",
  email: "john@example.org",
  cpf: "12345678901",
  phone: {
    area_code: "11",
    number: "123456789"
  }
}
```

#### Definindo valores de acréscimo/desconto

```ruby
payment.extra_amount = 123.45   # acréscimo
payment.extra_amount = -123.45  # desconto
```

#### URLS

```ruby
# URL de notificação
payment.notification_url = "http://example.org/notifications"

# URL de retorno
payment.return_url = "http://example.org/processando"
```

#### Definindo tempo de vida do código de pagamento

```ruby
payment.max_uses = 100
payment.max_age = 3600  # em segundos
```

#### Definindo encoding

```ruby
PagSeguro.encoding = "UTF-8" # UTF-8 ou ISO-8859-1
```

## Checkout Transparente

Encontre toda a documentação necessária para o checkout transparente aqui:
https://github.com/pagseguro/ruby/blob/master/docs/transparent_checkout.md

## Docker

[Docker](http://www.docker.com/) é uma ferramenta open-source que cria uma
camada de abstração e automação da virtualização do kernel do
GNU/Linux[\*](https://en.wikipedia.org/wiki/Docker_(software)).

Primeiro certifique-se de que o Docker está instalado e configurado
corretamente, em seguida construa a imagem:

    % docker build -t pagseguro .

E para entrar na imagem:

    % docker run --rm -it -v ${PWD}:/app pagseguro
    root@5c480dd6e22a:/app#

Ou se preferir você pode usar o
[docker-compose](https://docs.docker.com/compose/):

    % docker-compose run script
    root@c6697abac095:/app#

## Dúvidas?

Caso tenha dúvidas ou precise de suporte, acesse nosso [fórum].


## Licença

Copyright 2013 PagSeguro Internet LTDA.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

## Notas
 - O PagSeguro somente aceita pagamento utilizando a moeda Real brasileiro (BRL).
 - Certifique-se que o email e o token informados estejam relacionados a uma conta que possua o perfil de vendedor ou empresarial.
 - Certifique-se que tenha definido corretamente o charset de acordo com a codificação (ISO-8859-1 ou UTF-8) do seu sistema. Isso irá prevenir que as transações gerem possíveis erros ou quebras ou ainda que caracteres especiais possam ser apresentados de maneira diferente do habitual.
 - Para que ocorra normalmente a geração de logs, certifique-se que o diretório e o arquivo de log tenham permissões de leitura e escrita.

## Contribuições

Achou e corrigiu um bug ou tem alguma feature em mente e deseja contribuir?

* Faça um fork
* Adicione sua feature ou correção de bug (`git checkout -b my-new-feature`)
* Commit suas mudanças (`git commit -am 'Added some feature'`)
* Rode um push para o branch (`git push origin my-new-feature`)
* Envie um Pull Request

O código, os commits e os comentários devem ser em inglês.
Adicione exemplos para sua nova feature.
Se seu Pull Request for relacionado a uma versão específica, o Pull Request não deve ser enviado para o branch master e sim para o branch correspondente a versão.

  [Criar Requisições de Pagamentos]: https://devs.pagseguro.uol.com.br/docs/checkout-web
  [Consultar Transações por Código]: https://devs.pagseguro.uol.com.br/docs/pagamento-recorrente-consulta-pelo-codigo-de-adesao
  [Consultar Transações por Intervalo de Datas]: https://devs.pagseguro.uol.com.br/docs/pagamento-recorrente-consulta-por-intervalo-de-datas
  [Receber Notificações]: https://dev.pagseguro.uol.com.br/docs/api-notificacao-v1
  [Estornar Transações por Código]: https://devs.pagseguro.uol.com.br/docs/checkout-web-cancelamento-e-estorno
  [Cancelar Transações por Código]: https://devs.pagseguro.uol.com.br/docs/pagamento-recorrente-cancelamento-de-adesao
  [fórum]: http://forum.pagseguro.uol.com.br/
  [Ruby]: http://www.ruby-lang.org/pt/
  [Aitch]: https://github.com/fnando/aitch
