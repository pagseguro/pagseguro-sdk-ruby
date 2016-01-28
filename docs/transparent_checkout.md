# Checkout Transparente

Integrando seu sistema de comércio eletrônico com o Checkout Transparente você pode oferecer toda a segurança e comodidade do PagSeguro para os seus clientes no momento da compra, sem precisar sair do seu site ou e-commerce. Com ele é possível disponibilizar em seu site os meios de pagamento Cartão de Crédito, Débito Online e Boleto.

O Checkout Transparente está disponível para contas do tipo Vendedor e Empresarial. As seções seguintes indicarão como é possível integrar seu sistema de pagamentos ao Checkout Transparente do PagSeguro.

A API do Checkout Transparente oferece maior controle e flexibilidade sobre o processo de pagamento. Com essa integração o cliente fica no ambiente do seu e-commerce ou site durante todo o processo de compra, sem necessidade de cadastro ou páginas intermediárias de pagamento.
Para essa integração o PagSeguro criou alguns serviços que juntos possibilitam construir um checkout integrado, seguro e invisível para o comprador.

## Integração

Para fazer a integração do Checkout Transparente, você precisa seguir os seguintes passos:

- Iniciar uma sessão de pagamento (Todos os meios de pagamento)
- Obter a bandeira do cartão de crédito (Apenas para Cartão de Crédito)
- Obter o token do cartão de crédito (Apenas para Cartão de Crédito)
- Verificar as opções de parcelamento (Apenas para Cartão de Crédito)
- Obter a identificação do comprador (Todos os meios de pagamento)
- Efetuar o pagamento utilizando a API do Checkout Transparente (Todos os meios de pagamento)

### Iniciar Sessão de Pagamento

Para iniciar um Checkout Transparente é necessário ter um ID de sessão válido. Este serviço retorna o ID de sessão que será usado nas chamadas JavaScript.

```ruby
  session = PagSeguro::Session.create
  @session_id = session.id
```

### Integrações no browser

A API do Checkout Transparente possui funções JavaScript para algumas operações que devem ser executadas no browser do cliente, funções que serão descritas mais adiante. Para essas funções uma API JavaScript deve ser importada no final da página dos meios de pagamento:

```html
produção:
<script type="text/javascript" src="https://stc.pagseguro.uol.com.br/pagseguro/api/v2/checkout/pagseguro.directpayment.js"></script>

sandbox:
<script type="text/javascript" src="https://stc.sandbox.pagseguro.uol.com.br/pagseguro/api/v2/checkout/pagseguro.directpayment.js"></script>
```

Esse JavaScript possui um objeto chamado `PagSeguroDirectPayment`, que é a interface de acesso aos métodos. Após importar o arquivo, deve ser executado o método `setSessionId` com o ID de sessão gerado anteriormente.

```javascript
  PagSeguroDirectPayment.setSessionId('<%= @session_id %>');
```

Nas funções, os eventos de sucesso e erro ocorrem em chamadas callback no JavaScript que são passadas via JSON. Para isso, basta passar três funções JavaScript com nome 'success', 'error' e 'complete' via JSON na chamada dos métodos. A função 'complete' será chamada independente do retorno e as funções 'success' e 'error' serão chamadas dependendo do retorno, ou seja, se o retorno não possuir erro a função chamada será a 'success' e se possuir erro a função chamada será a 'error'.

### Obter identificação do comprador

Para realizar o Checkout Transparente á necessário enviar um identificador do comprador gerado pelo JavaScript. Para isso você deve utilizar o método `getSenderHash`. Esse método não possui parâmetros e retorna um identificador. O identificador é obrigatório para todos os meios de pagamento.

```javascript
  PagSeguroDirectPayment.getSenderHash();
```

**Atenção:** Esse método possui algumas dependências e por isso recomendamos que o `getSenderHash` não seja executado no onLoad da página. Você pode executá-lo, por exemplo, quando o cliente clicar no botão de conclusão de pagamento.

### Obter bandeira do cartão de crédito

Esse processo é necessário somente para o meio de pagamento **cartão de crédito**. O método `getBrand` é utilizado para verificar qual a bandeira do cartão que está sendo digitado. Esse método recebe por parâmetro o BIN do cartão (seis primeiros dígitos do cartão) e retorna dados como qual a bandeira, o tamanho do CVV, se possui data de expiração e qual algoritmo de validação. A chamada desse serviço não é obrigatória.

Exemplo:

```javascript
  PagSeguroDirectPayment.getBrand({
    cardBin: $("input#cartao").val(),
    success: function (response) {
      //bandeira encontrada
    },
    error: function (response) {
      //tratamento do erro
    },
    complete: function (response) {
      //tratamento comum para todas chamadas
    }
  });
```

Retorno:

```javascript
  {
    "brand": {
      "name":"visa",
      "bin":411111,
      "cvvSize":3,
      "expirable":true,
      "validationAlgorithm":"LUHN"
    }
  }
```

### Obter token do cartão de crédito

Esse processo é necessário somente para o meio de pagamento **cartão de crédito**. O método `createCardToken` é utilizado para gerar o token que representará o cartão de crédito na chamada para a API do Checkout Transparente. Este método recebe os seguintes dados: número do cartão (obrigatório), CVV (opcional para alguns cartões), data de expiração (opcional para alguns cartões) e a bandeira (opcional).

Exemplo:

```javascript
  var params = {
    cardNumber: $("input#cartao").val(),
    cvv: $("input#cvv").val(),
    expirationMonth: $("input#validadeMes").val(),
    expirationYear: $("input#validadeAno").val(),
    success: function (response) {
      //token gerado, esse deve ser usado na chamada da API do Checkout Transparente
    },
    error: function (response) {
      //tratamento do erro
    },
    complete: function (response) {
      //tratamento comum para todas chamadas
    }
  }

  // parâmetro opcional para qualquer chamada
  if($("input#bandeira").val() !== '') {
    params.brand = $("input#bandeira").val();
  }

  PagSeguroDirectPayment.createCardToken(params);
```

Retorno:

```javascript
  {
    "card":{
      "token":"653fe9044cf149f9b7db562431cb130d"
    }
  }
```

### Obter opções de parcelamento

Esse processo é necessário apenas para o meio de pagamento **cartão de crédito**. Caso queira mostrar as opções de parcelamento para o comprador, você deverá utilizar o método `getInstallments`. Esse método recebe o valor a ser parcelado (obrigatório) e a bandeira que se deseja obter o parcelamento, retornando as configurações de cada parcela sendo: valor total do pagamento (que deve ser enviado junto na API do Checkout Transparente), valor e quantidade da parcela (que também devem ser informados na API do Checkout Transparente) e um indicador se aquela parcela tem juros ou não (caso o vendedor tenha configurado uma promoção no PagSeguro).

Se não for informado uma bandeira como parâmetro na chamada, o método retornará os dados para todas bandeiras aceitas pelo PagSeguro.

Exemplo:

```javascript
  PagSeguroDirectPayment.getInstallments({
    amount: $("input#valorPagto").val(),
    brand: $("input#bandeira").val(),
    success: function (response) {
      //opções de parcelamento disponíveis
    },
    error: function (response) {
      //tratamento do erro
    },
    complete: function (response) {
      //tratamento comum para todas chamadas
    }
  });
```

Retorno:

```javascript
  {
    "error":false,
    "installments":{
      "visa":
      [
        {
          "quantity":1,
          "totalAmount":16,
          "installmentAmount":16,
          "interestFree":true
        },
        {
          "quantity":2,
          "totalAmount":16.48,
          "installmentAmount":8.24,
          "interestFree":false
        },
        {
          "quantity":3,
          "totalAmount":16.64,
          "installmentAmount":5.55,
          "interestFree":false
        }
      ]
    }
  }
```

## API do Checkout Transparente

Este serviço envia os dados do comprador e do pagamento para realizar a cobrança.

A criação das transações podem ser feitas utilizando três métodos de pagamento:

[Boleto Bancário](https://github.com/pagseguro/ruby/blob/master/examples/transaction/boleto_transaction_request.rb)

[Cartão de Crédito](https://github.com/pagseguro/ruby/blob/master/examples/transaction/credit_card_transaction_request.rb)

[Transferência Eletrônica](https://github.com/pagseguro/ruby/blob/master/examples/transaction/online_debit_transaction.rb)
