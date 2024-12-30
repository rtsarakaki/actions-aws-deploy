#!/bin/bash
set -e

# Definindo os parâmetros obrigatórios
STACK_NAME=$1
TEMPLATE_FILE=$2
AWS_REGION=$3
PARAMETER_OVERRIDES=$4
DRY_RUN=$5
CAPABILITIES=$6

# Função para verificar se uma variável está vazia e coletar os parâmetros faltantes
MISSING_PARAMS=()

check_required() {
  if [ -z "$1" ]; then
    MISSING_PARAMS+=("$2")
  fi
}

# Verificar todos os parâmetros obrigatórios
echo "Checking required parameters..."

check_required "$STACK_NAME" "STACK_NAME"
check_required "$TEMPLATE_FILE" "TEMPLATE_FILE"
check_required "$AWS_REGION" "AWS_REGION"

# Se houver parâmetros faltando, exibe uma mensagem de erro e encerra o script
if [ ${#MISSING_PARAMS[@]} -gt 0 ]; then
    echo "The following required parameters are missing: ${MISSING_PARAMS[@]}. Deployment will not proceed."
    exit 1
fi

echo "All required parameters were provided."

# Validar o template com cfn-lint
echo "Validating template with cfn-lint..."
cfn-lint $TEMPLATE_FILE --ignore-checks W

# Lógica para o Dry Run
if [ "$DRY_RUN" == "true" ]; then
    echo "Executing in Dry Run mode..."
    DRY_RUN_OPTION="--no-execute-changeset"
else
    DRY_RUN_OPTION=""
fi

# Construir a string de capacidades
CAPABILITIES_OPTION=""
if [ -n "$CAPABILITIES" ]; then
    CAPABILITIES_OPTION="--capabilities $CAPABILITIES"
fi

# Executar o deploy
echo "Starting deployment..."
aws cloudformation deploy \
    --stack-name "$STACK_NAME" \
    --template-file "$TEMPLATE_FILE" \
    --parameter-overrides $PARAMETER_OVERRIDES \
    --region "$AWS_REGION" \
    $CAPABILITIES_OPTION \
    $DRY_RUN_OPTION
