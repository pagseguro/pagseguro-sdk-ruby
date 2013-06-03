# PagSeguro

## Instalação

Adicione a biblioteca ao seu Gemfile.

```ruby
source "https://rubygems.org"
gem "pagseguro-oficial"
```

Execute o comando `bundle install`.

## Configuração

Para fazer a autenticação, você precisará configurar as credenciais do PagSeguro. Crie o arquivo `config/initializers/pagseguro.rb` com o conteúdo abaixo.

```ruby
PagSeguro.configure do |config|
  config.token = "seu token"
  config.email = "seu e-mail"
end
```

O token de segurança está disponível em sua [conta do PagSeguro](https://pagseguro.uol.com.br/integracao/token-de-seguranca.jhtml).

## Pagamentos

Para iniciar uma requisição de pagamento, você precisa instanciar a classe `PagSeguro::PaymentRequest`. Isso normalmente será feito em seu controller de checkout.

```ruby
class CheckoutController < ApplicationController
  def create
    # O modo como você irá armazenar os produtos que estão sendo comprados
    # depende de você. Neste caso, temos um modelo Order que referência os
    # produtos que estão sendo comprados.
    order = Order.find(params[:id])

    payment = PagSeguro::PaymentRequest.new
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

## Notificações

O PagSeguro irá notificar a URL informada no processo de checkout. Isso é feito através do método `PagSeguro::PaymentRequest#notification_url`. Esta URL irá receber o código da notificação e tipo de notificação. Com estas informações, podemos pegar as informações detalhadas sobre a ordem de pagamento.

```ruby
class NotificationsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :create

  def create
    transaction = PagSeguro::Transaction.find_by_code(params[:notificationCode])

    if transaction.errors.empty?
      # Processa a notificação. A melhor maneira de se fazer isso é realizar
      # o processamento em background. Uma boa alternativa para isso é a
      # biblioteca Sidekiq.
    end

    render nothing: true, status: 200
  end
end
```

## Consultas

### Transações abandonadas

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

## API

### PagSeguro::PaymentRequest

#### Definindo identificador do pedido

```ruby
payment.reference = "ref1234"
```

#### Definindo informações de entrega.

```ruby
payment = PagSeguro::PaymentRequest.new
payment.shipping = {
  type: "sedex",
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

Alternativamente você pode definir uma instância da classe `PagSeguro::Shipping`.

```ruby
shipping = {
  type: "sedex",
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

payment.shipping = shipping
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

# URL de abandono
payment.abandon_url = "http://example.org"
```

#### Definindo tempo de vida do código de pagamento

```ruby
payment.max_uses = 1
payment.max_age = 3600
```

## Contribuindo

1. Faça um fork do projeto
2. Crie um novo branch com sua funcionalidade (`git checkout -b my-new-feature`)
3. Faça o commit de suas alterações (`git commit -am 'Add some feature'`)
4. Envie o novo branch (`git push origin my-new-feature`)
5. Crie um Pull Request
