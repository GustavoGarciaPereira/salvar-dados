# Use uma imagem base do Ubuntu
FROM ubuntu:20.04

# Atualize o sistema e instale as dependências necessárias
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    gfortran \
    git \
    libblas-dev \
    liblapack-dev \
    libscalapack-mpi-dev \
    mpi-default-bin \
    mpi-default-dev \
    && rm -rf /var/lib/apt/lists/*

# Clone o repositório SIESTA
RUN git clone --recurse-submodules https://gitlab.com/siesta-project/siesta.git /opt/siesta

# Defina o diretório de trabalho
WORKDIR /opt/siesta

# Execute o script de submódulos
RUN ./stage_submodules.sh

# Crie um diretório para a construção
RUN mkdir build

# Defina o diretório de construção
WORKDIR /opt/siesta/build

# Execute o CMake e a construção
RUN cmake .. && make

# Defina o ponto de entrada do container
CMD ["bash"]
