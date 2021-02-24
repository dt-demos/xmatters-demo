#!/bin/bash

# this script will call the feature flag of the app to change version & send a push event
# to dynatrace for the configuration change
 
source ./env-vars.sh

if [ -z "${DYNATRACE_BASE_URL}" ]; then
  echo "Aborting: Missing DYNATRACE_BASE_URL"
  exit 1
fi
if [ -z "${DYNATRACE_API_TOKEN}" ]; then
  echo "Aborting: Missing DT_TENANT"
  exit 1
fi

PROJECT=dt-orders
echo ""
#######################################################
# process APP_BASE_URL argument
#######################################################
if [ -z "${1}" ]; then
  echo "Aborting: Missing APP_BASE_URL"
  echo "usage:   ./deploy.sh APP_BASE_URL STAGE SERVICE VERSION"
  echo "example: ./deploy.sh http://someurl staging customer-service 1"
  exit 1
else
  APP_BASE_URL=$1
fi

#######################################################
# process STAGE argument
#######################################################
if [[ "${2}" == "production" || "${2}" == "staging" ]]; then
  STAGE=$2
else
  echo "Aborting: STAGE missing or value is not 'production' or 'staging'"
  echo "usage:   ./deploy.sh APP_BASE_URL STAGE SERVICE VERSION"
  echo "example: ./deploy.sh http://someurl staging customer-service 1"
  exit 1
fi

#######################################################
# process SERVICE argument
#######################################################
if [[ "${3}" == "customer-service" || "${3}" == "order-service" ]]; then
  SERVICE=$3
  if [ "$SERVICE" = "customer-service" ]; then
    SERVICE_NAME=customer
  elif [ "$SERVICE" = "order-service" ]; then
    SERVICE_NAME=order
  fi
else
  echo "Aborting: Missing SERVICE"
  echo "usage:   ./deploy.sh APP_BASE_URL STAGE SERVICE VERSION"
  echo "example: ./deploy.sh http://someurl staging customer-service 1"
  exit 1
fi

#######################################################
# process VERSION argument
#######################################################
if [ -z "${4}" ]; then
  VERSION=1
else
  VERSION=$4
fi

clear
echo ""
echo ""
echo "APP_BASE_URL       : $APP_BASE_URL"
echo "STAGE              : $STAGE"
echo "SERVICE            : $SERVICE"
echo "SERVICE_NAME       : $SERVICE_NAME"
echo "VERSION            : $VERSION"
echo "DYNATRACE_BASE_URL : $DYNATRACE_BASE_URL"

EVENT_TYPE="CUSTOM_DEPLOYMENT"
DEPLOYMENT_PROJECT=$PROJECT
DEPLOYMENT_NAME="set to version $VERSION"
DEPLOYMENT_VERSION=$VERSION
SOURCE="custom script deploy.sh"
CI_BACK_LINK="https://www.dynatrace.com"
TAG_RULE="[{\"meTypes\":[\"SERVICE\"],\"tags\":[{\"context\":\"CONTEXTLESS\",\"key\":\"project\",\"value\":\"$PROJECT\"},{\"context\":\"CONTEXTLESS\",\"key\":\"service\",\"value\":\"$SERVICE\"},{\"context\":\"CONTEXTLESS\",\"key\":\"stage\",\"value\":\"$STAGE\"}]}]"

echo ""
echo "Setting Version to $VERSION"
curl -s "$APP_BASE_URL/$SERVICE_NAME/setversion/$VERSION" > /dev/null 

echo ""
echo "Waiting until ready"
./wait-until-ready.sh $APP_BASE_URL/$SERVICE_NAME/version

echo ""
echo "Sending DT event"

curl -X POST "$DYNATRACE_BASE_URL/api/v1/events" \
  -H "accept: application/json" \
  -H "Authorization: Api-Token $DYNATRACE_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"eventType\":\"$EVENT_TYPE\",\
    \"source\":\"$SOURCE\",\
    \"ciBackLink\":\"$CI_BACK_LINK\",\
    \"deploymentName\":\"$DEPLOYMENT_NAME\",\
    \"deploymentVersion\":\"$VERSION\",\
    \"deploymentProject\":\"$PROJECT\",\
    \"attachRules\":{\"tagRule\":$TAG_RULE}}"

echo ""
echo ""