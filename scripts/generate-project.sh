#!/bin/bash

# Verifica se o ficheiro .env existe
if [ -f .env ]; then
  # Lê o ficheiro linha a linha e exporta as variáveis
  export $(grep -v '^#' .env | xargs)
  echo "✅ Variáveis de ambiente carregadas do .env"
else
  echo "⚠️ Ficheiro .env não encontrado!"
fi

# Executa os comandos do Tuist
tuist install
tuist generate