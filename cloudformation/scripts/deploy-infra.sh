#!/bin/bash 

STACK_NAME=sampleawswebapp01
REGION=us-east-1
CLI_PROFILE=similoluwaokunowo
EC2_INSTANCE_TYPE=t3.micro 

GH_ACCESS_TOKEN=$(cat ~/.github/aws-the-good-parts-access-token)
GH_REPO_OWNER=$(cat ~/.github/aws-the-good-parts-username)
GH_REPO=$(cat ~/.github/aws-the-good-parts-repo)
GH_BRANCH=master

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --profile ${CLI_PROFILE} --query "Account" --output text)
CODEPIPELINE_BUCKET="$STACK_NAME-$REGION-codepipeline-$AWS_ACCOUNT_ID"

# Deploy the resources for the infra setup
echo -e "\n\n======= Deploying setup.yml template =======\n\n"
aws cloudformation deploy \
  --region $REGION \
  --profile $CLI_PROFILE \
  --stack-name ${STACK_NAME}-setup \
  --template-file cloudformation/setup.yml \
  --no-fail-on-empty-changeset \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides CodePipelineBucket=$CODEPIPELINE_BUCKET


# Deploy the CloudFormation template
echo -e "\n\n======= Deploying cloudformation template =======\n\n"
aws cloudformation deploy \
    --region $REGION \
    --profile $CLI_PROFILE \
    --stack-name $STACK_NAME \
    --template-file cloudformation/main.yml \
    --no-fail-on-empty-changeset \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides EC2InstanceType=$EC2_INSTANCE_TYPE \
      GitHubOwner=$GH_REPO_OWNER \
      GitHubRepo=$GH_REPO \
      GitHubBranch=$GH_BRANCH \
      GitHubPersonalAccessToken=$GH_ACCESS_TOKEN \
      CodePipelineBucket=$CODEPIPELINE_BUCKET

# If the deploy succeeded, show the DNS name of the created instance
if [ $? -eq 0 ]; then
  aws cloudformation list-exports \
    --profile $CLI_PROFILE \
    --query "Exports[?starts_with(Name, 'InstanceEndpoint')].Value" \
    --region $REGION
fi 

# Show the load balancer endpoint 
if [ $? -eq 0]; then 
  aws cloudformation list-exports \
    --profile $CLI_PROFILE \
    --query "Exports[?ends_with(Name, 'LoadBalancerEndpoint')].Value" \
    --region $REGION
fi 