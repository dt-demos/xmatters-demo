# Overview

# Keptn Setup

Follow the setup steps from this [README](https://github.com/dt-demos/keptn-k3s-demo#keptn-setup-on-k3s).

Just follow the steps in section `Keptn Setup on K3s` for only these two steps
* 1 Dynatrace
* 2 Provison a host for Keptn

Be sure to have the KEPTN URL and TOKEN that is output from the k3s installation script.

**DO NOT** follow the steps in section `Setup Demo App on the host`


# Keptn Demo app onboarding

From the VM running Keptn, perform these steps

1. clone this repo `git clone https://github.com/dt-demos/xmatters-demo.git`

1. navigate to the scripts directory `cd xmatters-demo/scripts`

1. make a creds.json file an update with your Dynatrace secrets `cp creds.template creds.json`

1. Run the helper script to onboard the demo application to keptn along with demo app resources files keptn requires for the Dynatrace SLI provider service. `./install-keptn.sh`

# Perform Keptn SLO validation

Once keptn and the project is setup, then from the VM with the keptn CLI, run this command

```
keptn send event start-evaluation --project=dt-orders --stage=staging --service=frontend --timeframe=5m
```

1. verify SLO results in keptn bridge
