#!/bin/bash

# this script calls the keptn CLI to onboard the sample application
# using the files in the keptn subfolder

source ./env-vars.sh

if [ -z "${DYNATRACE_BASE_URL}" ]; then
  echo "Aborting: Missing DYNATRACE_BASE_URL"
  exit 1
fi
if [ -z "${DYNATRACE_API_TOKEN}" ]; then
  echo "Aborting: Missing DT_TENANT"
  exit 1
fi

keptn create project dt-orders --shipyard=./keptn/shipyard.yaml
keptn create service frontend --project=dt-orders

keptn configure monitoring dynatrace --project=dt-orders

keptn add-resource --project=dt-orders \
  --stage=production \
  --resource=./keptn/dynatrace.conf.yaml \
  --resourceUri=dynatrace/dynatrace.conf.yaml

keptn add-resource --project=dt-orders \
  --stage=staging \
  --resource=./keptn/dynatrace.conf.yaml \
  --resourceUri=dynatrace/dynatrace.conf.yaml

# strip off https:// for what keptn expects
DT_TENANT=$(echo ${DYNATRACE_BASE_URL:8})  

kubectl create secret generic dynatrace-demo -n keptn \
  --from-literal="DT_TENANT=$DT_TENANT" \
  --from-literal="DT_API_TOKEN=$DYNATRACE_API_TOKEN"
