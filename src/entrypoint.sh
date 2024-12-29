#!/bin/bash
set -e

# Verificar as variáveis recebidas
echo "Received Parameters:"
echo "STACK_NAME: $1"
echo "TEMPLATE_FILE: $2"
echo "USER_PASSWORD: $3"
echo "AWS_REGION: $4"
echo "DRY_RUN: $5"

STACK_NAME=$1
TEMPLATE_FILE=$2
USER_PASSWORD=$3
AWS_REGION=$4
DRY_RUN=$5

echo "Stack Name: $STACK_NAME"
echo "Template File: $TEMPLATE_FILE"
echo "AWS Region: $AWS_REGION"
echo "Dry Run: $DRY_RUN"

# Lógica para o Dry Run
if [ "$DRY_RUN" == "true" ]; then
  DRY_RUN_OPTION="--no-execute-changeset"
else
  DRY_RUN_OPTION=""
fi

aws cloudformation deploy \
    --stack-name "$STACK_NAME" \
    --template-file "$TEMPLATE_FILE" \
    --parameter-overrides UserPassword="$USER_PASSWORD" \
    --capabilities CAPABILITY_NAMED_IAM \
    --region "$AWS_REGION" \
    --no-execute-changeset $DRY_RUN_OPTION
