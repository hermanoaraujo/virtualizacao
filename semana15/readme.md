Utilize como base a aplicação disponibilizada nesse repositório (https://github.com/IBM/guestbook/tree/master/v1/guestbook) e o seu respectivo chart helm (https://github.com/IBM/helm101/tree/master/charts/guestbook) para fazer o que se pede a seguir.

1) Crie um novo chart helm (use o comando helm create) para configurar a aplicação Guestbook. Porém, diferentemente do chart original, esse chart deverá gerenciar apenas os componentes referentes à aplicação Web. Os recursos referentes ao Redis devem ser gerenciados à parte utilizando um chart existente.
2) Use o chart do Redis disponibilizado no repositório da Bitnami (https://github.com/bitnami/bitnami-docker-redis) e instale-o à parte. 
3) Crie um script bash (ou módulo terraform) que irá ficar responsável por rodar os comandos helm, passando como argumento os arquivos values.yaml quando for apropriado
4) A estrutura do repositório deverá ser a seguinte:
- Guestbook
     config/
        values.yaml
- Redis
    config/
     - values.yaml
 deploy.sh (ou módulo terraform)
