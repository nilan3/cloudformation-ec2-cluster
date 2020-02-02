#!/bin/bash

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ENVIRONMENT="dev"
REGION="eu-west-2"
EC2_KEY_NAME="personal-key"

ACTION=$1

if [[ $ACTION == "setup" ]]
then
	aws cloudformation deploy \
	  --template-file cfn-setup-stack.yml \
	  --stack-name cfn-setup-stack \
	  --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
	  --region $REGION \
	  --parameter-overrides Ec2KeyName=${EC2_KEY_NAME} \
	  --no-execute-changeset
elif [[ $ACTION == "deploy" ]]
then
	aws s3 sync templates/ s3://aws-cloudformation-templates-${ENVIRONMENT}-${REGION}/templates/
	aws cloudformation deploy \
	  --template-file master-stack.yml \
	  --stack-name master-stack-$ENVIRONMENT \
	  --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
	  --role-arn arn:aws:iam::${ACCOUNT_ID}:role/AWSCloudFormationServiceRole \
	  --region $REGION \
	  --parameter-overrides Ec2KeyName=${EC2_KEY_NAME} \
	  --no-execute-changeset
else
	echo "Invalid argument"
	echo "Usage: cfn-deploy.sh [setup|deploy]"
fi
