# Use uma imagem base do Ubuntu
FROM ubuntu:20.04

# Definir a variável de ambiente para evitar interação durante a instalação do tzdata
ENV DEBIAN_FRONTEND=noninteractive

# Atualize o sistema e instale as dependências necessárias
RUN apt-get update && apt-get install -y \
    build-essential \
    gfortran \
    git \
    libblas-dev \
    liblapack-dev \
    libscalapack-mpi-dev \
    mpi-default-bin \
    mpi-default-dev \
    tzdata \
    wget \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Instalar CMake mais recente
RUN wget https://github.com/Kitware/CMake/releases/download/v3.21.3/cmake-3.21.3-linux-x86_64.sh && \
    chmod +x cmake-3.21.3-linux-x86_64.sh && \
    ./cmake-3.21.3-linux-x86_64.sh --skip-license --prefix=/usr/local && \
    rm cmake-3.21.3-linux-x86_64.sh

# Configurar o fuso horário
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
    echo "America/New_York" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata

# Clone o repositório SIESTA na versão v4.1.5
RUN git clone --branch v4.1.5 --recurse-submodules https://gitlab.com/siesta-project/siesta.git /opt/siesta

# Defina o diretório de trabalho
WORKDIR /opt/siesta

# Execute o script de submódulos
RUN chmod +x stage_submodules.sh && ./stage_submodules.sh

# Instalar ScaLAPACK corretamente
RUN apt-get install -y libscalapack-openmpi-dev

# Crie um diretório para a construção
RUN mkdir build

# Defina o diretório de construção
WORKDIR /opt/siesta/build

# Execute o CMake e a construção
RUN cmake .. && make

# Defina o ponto de entrada do container
CMD ["bash"]
