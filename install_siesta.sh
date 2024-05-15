#!/bin/bash

# Atualize os pacotes e instale as dependências necessárias
apt-get update
apt-get install -y make libmpich-dev libopenmpi-dev build-essential checkinstall \
    openmpi-bin openmpi-doc libopenmpi-dev liblapack-dev libscalapack-mpi-dev \
    libblacs-mpi-dev libscalapack-openmpi-dev libscalapack-mpich-dev gfortran \
    hdf5-tools netcdf-bin netcdf-doc

# Remova qualquer instalação anterior do SIESTA
# rm -rf siesta/

# Clone o repositório do SIESTA
git clone --branch v4.0.2 --recurse-submodules https://gitlab.com/siesta-project/siesta.git

# Navegue para o diretório de build
cd siesta/Obj/

# Execute o script de configuração
sh ../Src/obj_setup.sh && ../Src/configure

# Adicione a flag para permitir incompatibilidade de tipos
echo "FFLAGS += -fallow-argument-mismatch" >> arch.make

# Compile o SIESTA
make

cp siesta /usr/local/bin && cd ../../
