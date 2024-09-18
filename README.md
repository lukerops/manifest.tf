# manifest.tf

Um processador de manifestos YAML escrito inteiramente em Terraform.

---

## Introduçao

O manifest.tf é um módulo pensado para facilitar a criaçao de uma interface simplificada para seus projetos Terraform, assim, implementando funçoes como: criaçao, gerenciamento e depreciaçao de versoes, validaçao de tipo e mensagens de erro descritivas.

## Sobre

A idéia por trás do módulo gira em torno de dois tipos de manifestos YAML, sendo eles:
- Manifestos com a Definiçao de um Recurso Customizado (CustomResourceDefinition);
- Manifestos que descrevem um Recurso;

Assim, o módulo utiliza dos manifestos do tipo CustomResourceDefinition para criar um *schema* que será usado para processar os manifestos de Recurso.

<details>
<summary>Exemplo de Manifesto de CustomResourceDefinition</summary>

```yaml
apiVersion: manifest-tf.lukerops.com/v1alpha1
kind: CustomResourceDefinition
metadata:
  name: example-resource.example.manifest.tf
spec:
  group: example.manifest.tf
  kind: ExampleResource
  versions:
    - name: v1alpha1
      specSchema:
        type: object
        properties:
          displayName:
            type: string
          settings:
            type: object
            properties:
              labels:
                type: array
                items:
                  type: string
```

</details>
<details>
<summary>Exemplo de Manifesto de Recurso</summary>

```yaml
apiVersion: example.manifest.tf/v1alpha1
kind: ExampleResource
metadata:
  name: resource-terraform-unique-identifier
spec:
  displayName: resourceDisplayName
  settings:
    labels:
      - resource-from-team-a
```

</details>

### Retorno

Após realizar todas as validaçoes o módulo agrupa as informaçoes de forma a facilitar o uso do `for` para iterar e criar os recursos. Deste modo, temos o seguinte exemplo de retorno:

```terraform
resources = {
  (apiGroup) = {
    (kind) = {
      (metadata.name) = resourceManifest
    }
  }
}
```

<details>
<summary>Exemplo de retorno com os manifestos dos exemplos anteriores</summary>

```terraform
resources = {
  "example.manifest.tf" = {
    "ExampleResource" = {
      "resource-terraform-unique-identifier" = {
        "apiVersionName" = "v1alpha1"
        "apiGroup"       = "example.manifest.tf"
        "apiVersion"     = "example.manifest.tf/v1alpha1"
        "kind"           = "ExampleResource"
        "metadata" = {
          "name" = "resource-terraform-unique-identifier"
        }
        "spec" = {
          "displayName" = "resourceDisplayName"
          "settings" = {
            "labels" = ["resource-from-team-a"]
          }
        }
      }
    }
  }
}
```

</details>

### Uso

O módulo tem como entrada apenas uma lista com o nome dos arquivos YAML que ele irá validar. Assim, a recomendação de uso é:

```terraform
locals {
  # Essa linha é reponsável por listar todos os arquivos ".yaml" e ".yml" dentro da pasta "manifests"
  yamls = fileset(path.module, "./manifests/*.{yml,yaml}")
}

module "manifest-processor" {
  source = "github.com/lukerops/manifest.tf.git"
  yamls  = local.yamls
}
```

#### Exemplos

Os exemplos podem ser encontrados na [pasta de exemplos](examples/).

### Boas Práticas

Depois de utilizar o módulo em produçao com múltiplas versoes de um mesmo recursos e passar por alguns problemas, adotei algumas práticas que tornaram o gerenciamento das versoes mais simples. A ideia consiste em sempre criar um `map` com o mapeamento dos campos do manifesto para os campos do recurso para cada versao de manifesto e depois fazer o merge de todos esses `map`s. Desta forma, vamos unificar todas a criaçao de um recurso em um único `map`, ou seja, vamos precisar fazer apenas um `for_each` para gerenciar esse recurso Terraform, o que torna o desenvolvimento menor e mais fácil.

#### Exemplo

Considere que criamos uma interface para nosso projeto e que depois de um tempo identificamos que os campos mapeados inicialmente nao atendiam mais as necessidades do projeto. Com isso, criamos uma nova versao para os manifestos deste recurso.

> No exemplo, a versao nova foi criada para padronizar o `displayName` de todos os recursos do time.

```yaml
apiVersion: manifest-tf.lukerops.com/v1alpha1
kind: CustomResourceDefinition
metadata:
  name: example-resource.best-practice.example.manifest.tf
spec:
  group: best-practice.example.manifest.tf
  kind: ExampleResource
  versions:
    # Versao inicial que foi encontrado o problema
    - name: v1alpha1
      specSchema:
        type: object
        properties:
          displayName:
            type: string
          settings:
            type: object
            properties:
              labels:
                type: array
                items:
                  type: string
    # Versao que nao é mais possível definir o displayName
    - name: v1alpha2
      specSchema:
        type: object
        properties:
          team:
            type: string
          settings:
            type: object
            properties:
              labels:
                type: array
                items:
                  type: string
---
# Recurso criado antes da versao nova
apiVersion: best-practice.example.manifest.tf/v1alpha1
kind: ExampleResource
metadata:
  name: resource-a
spec:
  displayName: oldResource
  settings:
    labels:
      - resource-from-team-a
---
# Recurso criado depois da versao nova
apiVersion: best-practice.example.manifest.tf/v1alpha2
kind: ExampleResource
metadata:
  name: resource-b
spec:
  team: team-a
  settings:
    labels:
      - resource-from-team-a
```

**Dado os dois recursos criados no YAML anterior como garantiremos que se o `resource-a` for reescrito para a `v1alpha2` ele nao será recriado na infraestrutura?**
É para isso que serve o mapeamento para uma interface padronizado antes de jogarmos para o recurso Terraform, pois, assim, todas as versoes serao gerenciadas juntas e caso haja uma atualizaçao, o recurso nao seja recriado de forma erronea.

```terraform
locals {
  # Essa linha é reponsável por listar todos os arquivos ".yaml" e ".yml" dentro da pasta "manifests"
  yamls = fileset(path.module, "./manifests/*.{yml,yaml}")
}

module "manifest-processor" {
  source = "github.com/lukerops/manifest.tf.git"
  yamls  = local.yamls
}

locals {
  apiGroup = "best-practice.example.manifest.tf"
  kind     = "ExampleResource"
  exampleResources = merge(
    {
      for name, resource in module.manifest-processor.resources[local.apiGroup][local.kind] :
      name => {
        # os campos aqui devem ser os campos finais
        # utilizados na criacao do recurso
        displayName = resource.spec.displayName
        labels      = resource.spec.settings.labels
      }
      if resource.apiVersionName == "v1alpha1"
    },
    {
      for name, resource in module.manifest-processor.resources[local.apiGroup][local.kind] :
      name => {
        # os campos aqui devem ser os campos finais
        # utilizados na criacao do recurso
        displayName = "${name}-${resource.spec.team}"
        labels      = concat(resource.spec.settings.labels, [resource.spec.team])
      }
      if resource.apiVersionName == "v1alpha2"
    }
  )
}

resource "terraform_resource" "example" {
  for_each = local.exampleResources

  displayName = each.value.displayName
  labels      = each.value.labels
}
```

Com o código apresentado anteriormente é possível ter múltiplas versoes de um manifesto de um mesmo recurso sendo utilizado simultaneamente, além de tornar transparente a migraçao de uma *versao x* para uma *versao y*.
