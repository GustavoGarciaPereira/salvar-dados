#!/bin/bash

# Solicita a versão do SIESTA ao usuário
read -p "Digite a versão do SIESTA (padrão: v4.0.2): " SIESTA_VERSION
SIESTA_VERSION=${SIESTA_VERSION:-v4.0.2}

# Função para verificar se o SIESTA está instalado
function check_siesta_installed {
    if [ -d "siesta" ]; then
        if [ -f "siesta/Obj/siesta" ]; then
            INSTALLED_VERSION=$(cd siesta && git describe --tags)
            echo "SIESTA já está instalado. Versão: $INSTALLED_VERSION"
            return 0
        fi
    fi
    return 1
}

# Verifica se o SIESTA já está instalado
if check_siesta_installed; then
    exit 0
fi

# Atualize os pacotes e instale as dependências necessárias
apt-get update
apt-get install -y make libmpich-dev libopenmpi-dev build-essential checkinstall \
    openmpi-bin openmpi-doc libopenmpi-dev liblapack-dev libscalapack-mpi-dev \
    libblacs-mpi-dev libscalapack-openmpi-dev libscalapack-mpich-dev gfortran \
    hdf5-tools netcdf-bin netcdf-doc

# Remova qualquer instalação anterior do SIESTA
rm -rf siesta/

# Clone o repositório do SIESTA
git clone --branch $SIESTA_VERSION --recurse-submodules https://gitlab.com/siesta-project/siesta.git

# Navegue para o diretório de build
cd siesta/Obj/

# Execute o script de configuração
sh ../Src/obj_setup.sh && ../Src/configure

# Adicione a flag para permitir incompatibilidade de tipos
echo "FFLAGS += -fallow-argument-mismatch" >> arch.make

# Compile o SIESTA
make

cp siesta /usr/local/bin && cd ../../
