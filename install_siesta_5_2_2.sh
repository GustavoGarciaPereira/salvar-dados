# !/bin/bash
set -e  # Sai do script se qualquer comando falhar

# Instale dependências do sistema
echo "Instalando dependências..."
apt-get update && apt-get install -y \
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
    libscalapack-mpi-devapt-get clean && rm -rf /var/lib/apt/lists/*

# Crie diretório de instalação
INSTALL_DIR="/opt/siesta-install"
mkdir -p $INSTALL_DIR

# Clone o repositório do SIESTA
echo "Clonando o repositório SIESTA..."


git clone --branch 5.2.2 https://gitlab.com/siesta-project/siesta.git
cd siesta
git submodule update --init --recursive

# Crie e entre no diretório de build
mkdir -p build
cd build

# Verifique o caminho exato do arquivo libscalapack
echo "Verificando localização da biblioteca ScaLAPACK..."
SCALAPACK_PATH=$(find /usr -name "libscalapack*.so*" | head -1)
echo "ScaLAPACK encontrado em: $SCALAPACK_PATH"

# Configure e compile
echo "Configurando e compilando SIESTA..."
cmake .. \
    -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR \
    -DSIESTA_WITH_MPI=ON \
    -DSIESTA_WITH_FLOOK=OFF \
    -DSIESTA_WITH_NETCDF=ON \
    -DSIESTA_WITH_OPENMP=ON \
    -DSIESTA_WITH_ELSI=ON \
    -DCMAKE_Fortran_COMPILER=mpifort \
    -DCMAKE_C_COMPILER=mpicc \
    -DBLAS_LIBRARY=openblas \
    -DLAPACK_LIBRARY=lapack \
    -DSCALAPACK_LIBRARY="-lscalapack-openmpi" \
    -DCMAKE_BUILD_TYPE=Release

# Compile usando todos os núcleos disponíveis
echo "Compilando com $(nproc) núcleos..."
cmake --build . -j $(nproc)

# Instale
echo "Instalando SIESTA..."
cmake --install .

# Adicione ao PATH para o usuário atual
echo "Adicionando SIESTA ao PATH..."
echo "export PATH=\"$INSTALL_DIR/bin:\$PATH\"" >> ~/.bashrc

# Crie um link simbólico para o executável no /usr/local/bin
ln -sf $INSTALL_DIR/bin/siesta /usr/local/bin/siesta
ln -sf $INSTALL_DIR/bin/tbtrans /usr/local/bin/tbtrans

echo "Instalação do SIESTA 5.2.2 concluída!"
echo "Executável principal: $INSTALL_DIR/bin/siesta"
echo "Para usar o SIESTA, reinicie seu terminal ou execute: source ~/.bashrc"
