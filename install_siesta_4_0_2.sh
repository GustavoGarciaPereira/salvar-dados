#!/bin/bash

# Solicita a versão do SIESTA ao usuário com valor padrão
read -p "Digite a versão do SIESTA (padrão: v4.0.2): " SIESTA_VERSION
SIESTA_VERSION=${SIESTA_VERSION:-v4.0.2}

# Função para verificar se o SIESTA está instalado
check_siesta_installed() {
    if [ -d "siesta" ] && [ -f "siesta/Obj/siesta" ]; then
        INSTALLED_VERSION=$(cd siesta && git describe --tags)
        echo "SIESTA já está instalado. Versão: $INSTALLED_VERSION"
        return 0
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
    libscalapack-openmpi-dev libscalapack-mpich-dev gfortran \
    hdf5-tools netcdf-bin netcdf-doc gcc

#Remova qualquer instalação anterior do SIESTA
rm -rf siesta/

# Clone o repositório do SIESTA com submódulos
git clone --branch $SIESTA_VERSION --recurse-submodules https://gitlab.com/siesta-project/siesta.git

# Navegue para o diretório de build
cd siesta/Obj/

# Execute o script de configuração
sh ../Src/obj_setup.sh
../Src/configure --enable-openmp

# Adicione a flag para permitir incompatibilidade de tipos no arquivo de configuração
# e habilite o suporte para OpenMP
echo "FFLAGS += -fallow-argument-mismatch -fopenmp" >> arch.make
echo "LDFLAGS += -fopenmp" >> arch.make
wget http://www.netlib.org/scalapack/scalapack-2.1.0.tgz
tar xzf scalapack-2.1.0.tgz
cd scalapack-2.1.0
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DBUILD_SHARED_LIBS=ON \
      ..
make -j$(nproc)
sudo make install
# Compile o SIESTA
make

# Copie o binário compilado para um local no PATH
cp siesta /usr/local/bin && cd ../../
