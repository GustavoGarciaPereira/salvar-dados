FROM ubuntu:22.04

# Instale dependências do sistema, com atenção especial às bibliotecas de álgebra linear
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

# Clone o repositório do SIESTA
WORKDIR /opt
RUN git clone https://gitlab.com/siesta-project/siesta.git && \
    cd siesta && \
    git submodule update --init --recursive

# Configure e compile com caminhos explícitos para as bibliotecas
RUN mkdir /opt/siesta/build && cd /opt/siesta/build && \
    cmake -DCMAKE_INSTALL_PREFIX=/opt/siesta-install \
          -DSIESTA_WITH_MPI=ON \
          -DSIESTA_WITH_NETCDF=ON \
          -DSIESTA_WITH_OPENMP=ON \
          -DSIESTA_WITH_ELSI=ON \
          -DCMAKE_Fortran_COMPILER=mpifort \
          -DCMAKE_C_COMPILER=mpicc \
          -DBLAS_LIBRARIES=/usr/lib/x86_64-linux-gnu/libopenblas.so \
          -DLAPACK_LIBRARIES=/usr/lib/x86_64-linux-gnu/liblapack.so \
          -DSCALAPACK_LIBRARIES=/usr/lib/x86_64-linux-gnu/libscalapack-openmpi.so \
          .. && \
    cmake --build . -j $(nproc) && \
    cmake --install .

# Adicione ao PATH
ENV PATH="/opt/siesta-install/bin:${PATH}"