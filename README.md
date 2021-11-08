# ShippingValidate

# Decisões tomadas no projeto

  Para poder realizar a validação do cep e preço baseado em um arquivo com as regras definidas de fretes
optei por utilizar o 'escript' do Elixir no qual gera um executável binário que roda por linha de comando
e assim aceita passar o cep, preço e o caminho do input_file para retorno dos dados.
  Na arquitetura do projeto foi utilizada apenas uma lib para conversão e leitura dos dados em json.
O arquivo `shipping_validate.ex` possui apenas uma função que roda a validação dos dados (cep, price, input_file),
as responsabilidades no entanto foram dividas em pequenos contextos `validates` e `core` que tem a responsabilidade de
"validar e extrair" os dados passados e "transformar e retornar" o resultado esperado respectivamente.
  O módulo `cli.ex` é responsável por conter o código que o executável irá rodar.
  Cada módulo com seu respectivo contexto possui um arquivo de teste correspondente com testes específicos para cada contexto.

# Compilar e gerar o executável

  ## Pré-requisitos

  - Rodar `asdf install` para rodar a versão correta do elixir (caso utilize como package manager)
  - `mix deps.get` para baixar as dependências do projeto

  Para compilar e gerar o executável apenas rode o comando:

  - `mix escript.build`

  O arquivo será gerado na raiz do projeot com nome de `shipping_validate`

# Como funciona

  O programa `./shipping_validate` (executável) roda no terminal os seguintes argumentos
  `./shipping_validate cep price --input-file-path=./default.json`

  - O input_file_path é o caminho do arquivo de configuração se não for passado vai pegar o padrão `./default.json`
  - O cep é aceito no seguinte formato `00000000` com 8 dígitos (caso tenha o tamanho ou o formato estejam errados irá retornar erro)
  - price (number / string)
  
  Irá retornar a resposta no formato json de acordo com o que foi definido

# Exemplo

  ## Comando no terminal sem arquivo de regras

  `./shipping_validate 15004001 20000`
  
  ## Comando no terminal com arquivo de regras
  
  `./shipping_validate 15004001 20000 --input-file-path=./default.json`

# Bibliotecas utilizadas

  Utilizei as bibliotecas:

    - {:jason, "~> 1.2"} / Para conversão, leitura e escrita de dados em json