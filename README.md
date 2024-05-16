# Projeto SIESTA em Docker

Este repositório contém todas as configurações necessárias para executar o SIESTA, um software de simulação de moléculas, em um ambiente Docker isolado. Este ambiente facilita a instalação, configuração e teste do SIESTA, garantindo a reprodução e consistência entre diferentes máquinas.

## Pré-requisitos

Antes de iniciar, certifique-se de que o Docker e o Docker Compose estão instalados em sua máquina. Estas ferramentas são essenciais para construir e executar o contêiner que hospeda o SIESTA.

## Configuração

Clone este repositório para obter todos os arquivos necessários. O repositório inclui o Dockerfile, docker-compose.yml, scripts de instalação e configuração, e outros recursos necessários.

```bash
git clone [URL do Repositório]
cd [Nome do Diretório do Repositório]
```

## Construção do Ambiente Docker

Para construir a imagem Docker que contém o SIESTA e todas as suas dependências, execute o seguinte comando no diretório raiz do projeto:

```bash
docker-compose build
```

## Execução do Contêiner

Após a construção da imagem, inicie o contêiner com o seguinte comando:

```bash
docker-compose up
```

## Acessando o Ambiente de Testes

Para acessar o contêiner em execução e interagir com o ambiente de testes, use:

```bash
docker exec -it siesta_container bash
```

## Executando Simulações

Comando para dar a permissão adequalda para a pasta 'data', para ser possivel acessar ela dentro do docker 
```bash
sudo chmod -R 777 ./data 
```


Para executar uma simulação específica, você pode usar o seguinte comando dentro do contêiner:

```bash
docker exec siesta_container bash -c "cd /data && siesta < input.fdf | tee output.out"
```

Este README oferece uma visão geral clara e instruções passo a passo para que os usuários possam facilmente configurar e começar a usar o projeto. Ajuste os comandos e informações de contato conforme necessário para se adequar ao seu projeto específico.