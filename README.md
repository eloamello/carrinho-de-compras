# Carrinho de Compras

## Descrição
O projeto consiste em uma API de carrinho de compras, onde o usuário pode fazer operações em produtos e carrinhos.
Os carrinhos são guardados na sessão.

### Possíveis operações:
- Adicionar produto
- Remover produto
- Editar produto
- Listar todos os produtos
- Listar apenas um produto
- Listar produtos de um carrinho (baseado na sessão)
- Adicionar produto ao carrinho
- Remover produto do carrinho
- Mudar a quantidade de um produto que já está no carrinho

São marcados como inativos os produtos que não tiveram alterações (adição e remoção) nas últimas 3 horas. 
Caso um carrinho esteja inativo por 7 dias, ele é removido. Isto é feito utilizando o sidekiq.

## Informações técnicas:
**Dependências:**

- ruby 3.3.1
- rails 7.1.3.2
- postgres 16
- redis 7.0.15

### Como executar o projeto

**Executando a app sem o docker:**

Para instalar as dependências:
```bash
bundle install
```
Para executar o sidekiq:
```bash
bundle exec sidekiq
```

Para executar o projeto rails:
```bash
bundle exec rails server
```

Para executar os testes:
```bash
bundle exec rspec
```

**Executando com o docker:**

Para construir a imagem:
```bash
docker-compose build
```
Para subir a aplicação:
```bash
docker-compose up
```