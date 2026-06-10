#!/bin/bash

# =================================================================
# Script de Configuração Rápida do GH (GitHub CLI)
# =================================================================

# 1. Defina o Hostname do seu GitHub (padrão: github.com)
HOST="github.com"

# 2. Cole seu Personal Access Token (PAT) abaixo (Opcional se usar 'gh auth login')
# Se deixado vazio, o script tentará 'gh auth login'.
TOKEN=""

# Verificação básica
if [ -z "$TOKEN" ]; then
    echo "ℹ️ Token não informado. Iniciando login interativo via 'gh auth login'..."
    gh auth login -h "$HOST"
else
    echo "🚀 Configurando gh para $HOST usando o token fornecido..."
    echo "$TOKEN" | gh auth login -h "$HOST" --with-token
fi

if [ $? -eq 0 ]; then
    echo "✅ Configuração concluída com sucesso!"
    gh auth status -h "$HOST"
else
    echo "❌ Falha na configuração. Verifique seu Host e Token."
fi
