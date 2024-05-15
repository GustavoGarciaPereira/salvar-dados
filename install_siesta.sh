#!/bin/bash

# Definir a versão do SIESTA
SIESTA_VERSION=${1:-v4.1.5}

# Atualizar pacotes e instalar dependências
sudo apt-get update && sudo apt-get install -y \
    make \
    libmpich-dev \
    libopenmpi-dev \
    build-essential \
    checkinstall \
    openmpi-bin \
    openmpi-doc \
    liblapack-dev \
    libscalapack-mpi-dev \
    libscalapack-openmpi-dev \
    libscalapack-mpich-dev \
    gfortran \
    hdf5-tools \
    netcdf-bin \
    netcdf-doc \
    wget \
    pkg-config \
    tzdata \
    git

# Instalar CMake mais recente
wget https://github.com/Kitware/CMake/releases/download/v3.21.3/cmake-3.21.3-linux-x86_64.sh && \
    chmod +x cmake-3.21.3-linux-x86_64.sh && \
    sudo ./cmake-3.21.3-linux-x86_64.sh --skip-license --prefix=/usr/local && \
    rm cmake-3.21.3-linux-x86_64.sh

# Configurar o fuso horário
sudo ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && \
    echo "America/Sao_Paulo" | sudo tee /etc/timezone && \
    sudo dpkg-reconfigure -f noninteractive tzdata

# Clonar o repositório SIESTA na versão especificada
git clone --branch $SIESTA_VERSION --recurse-submodules https://gitlab.com/siesta-project/siesta.git /opt/siesta

# Definir o diretório de trabalho
cd /opt/siesta

# Executar o script de submódulos


# Criar um diretório para a construção
mkdir -p Obj

# Definir o diretório de construção
cd Obj

# Executar a configuração e a construção
../Src/obj_setup.sh && ../Src/configure && make

# Copiar o executável para /usr/local/bin
sudo cp siesta /usr/local/bin

echo "Instalação e compilação do SIESTA concluídas."
