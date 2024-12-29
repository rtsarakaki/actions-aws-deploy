#!/bin/bash
set -e

STACK_NAME=$1
TEMPLATE_FILE=$2
AWS_REGION=$3
DRY_RUN=$4

aws cloudformation deploy \
    --stack-name $STACK_NAME \
    --template-file $TEMPLATE_FILE \
    --region $AWS_REGION
    --parameter-overrides UserPassword=${{ secrets.USER_PASSWORD }} \
    --capabilities CAPABILITY_NAMED_IAM
