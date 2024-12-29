#!/bin/bash
set -e

STACK_NAME=$1
TEMPLATE_FILE=$2
USER_PASSWORD=$3
AWS_REGION=$4
DRY_RUN=$5

echo "Stack Name: $STACK_NAME"
echo "Template File: $TEMPLATE_FILE"
echo "AWS Region: $AWS_REGION"
echo "Dry Run: $DRY_RUN"

aws cloudformation deploy \
    --stack-name "$STACK_NAME" \
    --template-file "$TEMPLATE_FILE" \
    --parameter-overrides UserPassword="$USER_PASSWORD" \
    --capabilities CAPABILITY_NAMED_IAM \
    --region "$AWS_REGION" \
    --no-execute-changeset $DRY_RUN
