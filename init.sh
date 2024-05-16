#!/bin/bash

# Caminho para a pasta
folder="data"

# Verifica se a pasta já existe
if [ ! -d "$folder" ]; then
    # Cria a pasta
    mkdir "$folder"
    # Atribui permissão 777 à pasta
    sudo chmod 777 "$folder"
    echo "Pasta 'data' criada e permissões definidas."
else
    echo "Pasta 'data' já existe."
fi
