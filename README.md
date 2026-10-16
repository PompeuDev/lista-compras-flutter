# 🛒 Lista de Compras (Flutter)

Aplicativo simples de lista de compras desenvolvido inteiramente em Flutter para a prova CP2.

## Descrição
O usuário pode adicionar produtos, marcar os itens já comprados e excluir produtos da lista. A tela é atualizada automaticamente a cada alteração.

## Gerenciamento de estado
Feito com `setState`, chamado ao adicionar, marcar/desmarcar ou remover um produto.

## Funções lógicas (regras de negócio)
- `_adicionarProduto()`: valida nome obrigatório, quantidade >= 1 e impede produtos duplicados.
- `_alternarComprado(index)`: alterna o status de comprado.
- `_removerProduto(index)`: exclui o produto da lista.
- `_totalComprados`: calcula quantos itens já foram comprados (usado na barra de progresso).

## Requisitos atendidos
- [x] Uso de `setState`
- [x] Função lógica com regra de negócio
- [x] Input de dados do usuário (`TextField`)
- [x] Ação através de botão (adicionar / remover / checkbox)
- [x] Renderização em tempo real (lista, contador e barra de progresso)

## Como executar
```bash
flutter pub get
flutter run
```

## Estrutura do projeto
```
lista_compras/
├── lib/main.dart            # código do app
├── test/widget_test.dart    # teste simples
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
```

## Primeira execução
Se as pastas de plataforma (android, ios, web...) não existirem, rode dentro da pasta do projeto:
```bash
flutter create .
flutter pub get
flutter run
```
