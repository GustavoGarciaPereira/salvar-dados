Para testar o ambiente Docker configurado para o projeto SIESTA, siga os passos abaixo:

1. **Construir a Imagem Docker:**
   No diretório onde estão os arquivos `Dockerfile` e `docker-compose.yml`, execute:
   ```sh
   docker-compose build
   ```

2. **Iniciar o Contêiner:**
   Após a construção da imagem, inicie o contêiner com:
   ```sh
   docker-compose up
   ```

3. **Acessar o Contêiner:**
   Com o contêiner em execução, abra um terminal interativo dentro dele:
   ```sh
   docker exec -it siesta_container bash
   ```

4. **Testar a Compilação do SIESTA:**
   Dentro do contêiner, navegue até o diretório de construção e execute os testes:
   ```sh
   cd /opt/siesta/build
   make test
   ```

Esses passos permitirão verificar se o SIESTA foi compilado corretamente dentro do contêiner Docker.


```sh
docker exec siesta_container bash -c "cd /data && siesta < gr_1cooh+ac_1.fdf | tee saida.out"  
```