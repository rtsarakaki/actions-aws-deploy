#!/bin/bash
set -e

STACK_NAME=$1
TEMPLATE_FILE=$2
AWS_REGION=$3
DRY_RUN=$4

if aws cloudformation describe-stacks --stack-name $STACK_NAME --region $AWS_REGION 2>/dev/null; then
  echo "Stack $STACK_NAME encontrada. Atualizando..."
  aws cloudformation update-stack \
    --stack-name $STACK_NAME \
    --template-body file://$TEMPLATE_FILE \
    --region $AWS_REGION
else
  echo "Stack $STACK_NAME não encontrada. Criando..."
  aws cloudformation create-stack \
    --stack-name $STACK_NAME \
    --template-body file://$TEMPLATE_FILE \
    --region $AWS_REGION
fi
