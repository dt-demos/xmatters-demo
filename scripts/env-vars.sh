# this script reads the creds.json values into environment variables
# this script is meant to be called as 
# 'source ./env-vars.sh'

# environment variables expected for keptn and deployment script
export DYNATRACE_BASE_URL=$(cat creds.json | jq -r ".DYNATRACE_BASE_URL")
export DYNATRACE_API_TOKEN=$(cat creds.json | jq -r ".DYNATRACE_API_TOKEN")

# environment variables expected for monaco
export MONACO_XMATTERS_PROBLEM_TRIGGER_URL=$(cat creds.json | jq -r ".MONACO_XMATTERS_PROBLEM_TRIGGER_URL")
export MONACO_KEPTN_PROBLEM_KEPTN_TOKEN=$(cat creds.json | jq -r ".MONACO_KEPTN_PROBLEM_KEPTN_TOKEN")
export MONACO_KEPTN_PROBLEM_WEBHOOK_URL=$(cat creds.json | jq -r ".MONACO_KEPTN_PROBLEM_WEBHOOK_URL")
export MONACO_DASHBOARD_OWNER=$(cat creds.json | jq -r ".MONACO_DASHBOARD_OWNER")
