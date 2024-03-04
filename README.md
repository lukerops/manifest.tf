# tf-gapi

Um validador de manifestos kubernetes-like para facilitar e padronizar a entrada de dados em seus projetos Terraform.

---

### Contexto

Alguns projetos precisam de atualizações nas entrada dos dados frequentemente (ex: gestão de acessos), e sempre que isso é necessário, nós temos a tendencia de deixar esses dados em HCL mesmo, porém, muitas vezes isso acaba criando uma dependência direta com o nosso time para adicionar esses novos dados. Alguns times já passaram por isso e "evoluiram". Para diminuir essa dependência eles criam interfaces mais simples para que as pessoas não precisem conhecer de Terraform, HCL, ou a lógica interna do projeto para poder ajudar com as demandas, assim, nascem interfaces YAML/JSON para códigos Terraform.

Esse caminho resolve o problema inicial (facilidade de uso) mas trás consigo outros tipos de problemas, como: mudança da interface, documentação da interface e manutenção do código. Agora que várias pessoas, muitas vezes até externas ao time que mantém o projeto, falam a mesma interface, caso seja necessário altera-la, tudo precisa ser feito com muito mais cautela. Mas a pergunta que fica é: **Como vou conseguir manter 2 ou mais versões da minha interface ao mesmo tempo? Terei que escrever um parser para cada versão em Terraform? É possível fazer isso em Terraform?**

Este módulo é a resposta para essas perguntas. Se baseando nas interfaces utilizadas pelo Kubernetes, por já terem passado na validação do tempo e estarem bem maduras, esse módulo permite a criação de recursos customizados (`CustomResources` para quem está mais familiarizado com Kubernetes). Esses recursos costomizados são manifestos, em formato específico, cujo o propósito é a definição de um schema para validar outros manifestos que sejam "intâncias" desse recurso. Com isso, o módulo fica responsável por toda a validação do formato e tipos de dados descritos nesses manifestos, apresentando uma mensagem de erro simples e direta para tornar o uso da ferramenta mais agradável. E não menos importante, o módulo visa facilitar a implementação de novas ferramentas, entregando toda a informação validada e agrupada para que possa ser utilizada em projetos Terraform.

### Uso

#### Terraform

Para tornar seu uso mais simples, o módulo tem como entrada apenas uma lista com o nome dos arquivos YAML que ele irá validar. Assim, a recomendação de uso é:

```terraform
locals {
  # Essa linha é reponsável por listar todos os arquivos ".yaml" e ".yml" dentro da pasta "manifests"
  yamls = fileset(path.module, "./manifests/*.{yml,yaml}")
}

module "tf-gapi" {
  source = "github.com/lukerops/tf-gapi.git"
  yamls  = local.yamls
}
```

#### Exemplos

Os exemplos podem ser encontrados na [pasta de exemplos](examples/)

# Guia de desenvolvimentos

O projeto é desenvolvido usando o [framework de teste](https://developer.hashicorp.com/terraform/language/tests) do próprio terraform.

## Rodando os testes

Para rodar os testes você precisará usar o terrform 1.6+. Primeiro precisa inicializar o proejto terraform, com:

```
terraform init
```

Os testes estão em `test/` e podem ser rodados com:

```
terraform test
```
