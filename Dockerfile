# Use uma imagem base com as ferramentas necessárias
FROM ubuntu:22.04

# Instale as dependências
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    wget \
    libopenmpi-dev \
    gfortran \
    openmpi-bin \
    libnetcdf-dev \
    libnetcdff-dev \
    libopenblas-dev \
    liblapack-dev \
    libscalapack-mpi-dev \
    && rm -rf /var/lib/apt/lists/*
# Defina o diretório de trabalho
# WORKDIR /siesta
COPY install_siestat.sh .

RUN chmod +x install_siestat.sh
RUN ./install_siestat.sh

# RUN cd data && siesta < input.fdf | tee saida.out
# Comando padrão
CMD ["tail", "-f", "/dev/null"]
