# Usa uma imagem base do Ubuntu
FROM ubuntu:latest

# Atualiza o sistema e instala as dependências necessárias
RUN apt-get update && apt-get install -y \
    git \
    gfortran \
    cmake \
    libopenmpi-dev \
    liblapack-dev \
    libscalapack-openmpi-dev \
    libnetcdff-dev \
    libreadline-dev

# Clona o repositório do Siesta
RUN git clone https://gitlab.com/siesta-project/siesta.git /siesta

# Define o diretório de trabalho
WORKDIR /siesta

# Compila o Siesta
RUN cmake -S. -B_build -DCMAKE_INSTALL_PREFIX=/path/to/installation \
    && cmake --build _build -j 4 \
    && cmake --install _build
