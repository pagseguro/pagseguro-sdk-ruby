## Next release - 2.5.0

- Atualizado a sintaxe do rspec

2.4.0

- Estorno de transações
- Cancelamento de transações
- Consulta de histórico de status de transações

2.3.0

- Modelo de aplicações (autenticação na api como vendedor ou como aplicação)
- Removendo utilização de threads para armazenar o objeto de configuração (a abordagem com threads não funciona no Rails 4, que é threadsafe)
- Adicionando deprecation warnings para configuration writers do módulo PagSeguro. Será removido no futuro. Utilizar o bloco de configuração.

2.2.0

- Estorno de transações
- Cancelamento de transações
- Consulta de histórico de status de transações

2.3.0

- Modelo de aplicações (autenticação na api como vendedor ou como aplicação)
- Removendo utilização de threads para armazenar o objeto de configuração (a abordagem com threads não funciona no Rails 4, que é threadsafe)
- Adicionando deprecation warnings para configuration writers do módulo PagSeguro. Será removido no futuro. Utilizar o bloco de configuração.

2.2.0

- Checkout transparente

2.1.1

- Correção de bug na busca de transações por data

2.1.0

- Utilização da versão 3 da api de notificações e consultas (OBS.: o serviço de consulta a transações abandonadas ainda utiliza a versão 2)
- O serviço de parcelas (installment) usará fixamente a versão 2 da api
- Correção de um bug que concatenava o status da transação com o status de um pagamento

2.0.8

- Consulta de opções de parcelamento

2.0.7

 - Suporte para adicionar parâmetros dinamicamente na criação de requisições de pagamentos (isso possibilita a utilização de parâmetros da api que ainda não foram mapeados na gem)

2.0.6

 - Adicionando environment sandbox, entre outras melhorias

2.0.5

 - Fixa a versão da biblioteca Aitch; a versão antiga não possui a mesma API utilizada nesta gem.

2.0.4

 - PaymentRequest com email e token alternativos

2.0.3

 - Ajuste no parser XML e paginação de relatórios.
 - Incluindo parâmetro para indicar a página inicial em uma busca de transações.
 - Correções de testes.

2.0.2

 - Atualização dos tipos e códigos de meio de pagamento.
 - Correção do exemplo payment_request.

2.0.1

 - Classes de domínios que representam pagamentos, notificações e transações.
 - Criação de checkouts via API.
 - Tratamento de notificações de pagamento enviadas pelo PagSeguro.
 - Consulta de transações.
