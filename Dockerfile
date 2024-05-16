# Use uma imagem base com as ferramentas necessárias
FROM ubuntu:22.04

# Instale as dependências
RUN apt-get update && \
    apt-get install -y build-essential gfortran libblas-dev liblapack-dev libfftw3-dev git wget python3 python3-pip && \
    apt-get clean

# Defina o diretório de trabalho
# WORKDIR /siesta
COPY install_siesta.sh .

RUN chmod +x install_siesta.sh
RUN ./install_siesta.sh

RUN cd data && siesta < input.fdf | tee saida.out
# Comando padrão
CMD ["tail", "-f", "/dev/null"]
