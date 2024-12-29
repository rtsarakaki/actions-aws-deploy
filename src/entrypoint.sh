#!/bin/bash
set -e

# Definindo os parâmetros obrigatórios
STACK_NAME=$1
TEMPLATE_FILE=$2
USER_PASSWORD=$3
AWS_REGION=$4
DRY_RUN=$5

# Função para verificar se uma variável está vazia e coletar os parâmetros faltantes
MISSING_PARAMS=()

check_empty() {
  if [ -z "$1" ]; then
    MISSING_PARAMS+=("$2")
  fi
}

# Verificar todos os parâmetros obrigatórios
echo "Verificando parâmetros..."

check_empty "$STACK_NAME" "STACK_NAME"
check_empty "$TEMPLATE_FILE" "TEMPLATE_FILE"
check_empty "$USER_PASSWORD" "USER_PASSWORD"
check_empty "$AWS_REGION" "AWS_REGION"

# Se houver parâmetros faltando, exibe uma mensagem de erro e encerra o script
if [ ${#MISSING_PARAMS[@]} -gt 0 ]; then
  echo "Faltaram os seguintes parâmetros obrigatórios: ${MISSING_PARAMS[@]}. O deploy não será executado."
  exit 1
fi

echo "Todos os parâmetros obrigatórios foram passados."

echo "Stack Name: $STACK_NAME"
echo "Template File: $TEMPLATE_FILE"
echo "AWS Region: $AWS_REGION"
echo "Dry Run: $DRY_RUN"

# Instalar cfn-lint se não estiver disponível
if ! command -v cfn-lint &> /dev/null
then
    echo "cfn-lint não encontrado. Instalando..."
    pip install cfn-lint
fi

# Validar o template com cfn-lint
echo "Validando o template com cfn-lint..."
cfn-lint $TEMPLATE_FILE

# Lógica para o Dry Run
if [ "$DRY_RUN" == "true" ]; then
  DRY_RUN_OPTION="--no-execute-changeset"
else
  DRY_RUN_OPTION=""
fi

# Executar o deploy
echo "Iniciando o deploy..."
aws cloudformation deploy \
    --stack-name "$STACK_NAME" \
    --template-file "$TEMPLATE_FILE" \
    --parameter-overrides UserPassword="$USER_PASSWORD" \
    --capabilities CAPABILITY_NAMED_IAM \
    --region "$AWS_REGION" \
    $DRY_RUN_OPTION
