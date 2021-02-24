# Welcome 

The repo contains the configuration files to support [Dynatrace Monitoring as Code](https://github.com/dynatrace-oss/dynatrace-monitoring-as-code) framework.

# Prereqs

Install [Dynatrace monoco binary 1.4.0](https://github.com/dynatrace-oss/dynatrace-monitoring-as-code/releases/tag/v1.4.0).  

On Mac:

* downloaded monaco binary `wget -O monaco https://github.com/dynatrace-oss/dynatrace-monitoring-as-code/releases/download/v1.4.0/monaco-darwin-10.6-amd64`
* make monaco executable `chmod +x monaco`
* moved monaco to be in path `mv monaco /usr/local/bin/monaco`
* when prompted after first time execution, adjust mac security settings to trust `monaco` 

# How to apply Dynatrace configuration using monaco

1. Run the helper script to setup the environment variables.  This assumes you have created the `creds.json` file in the scripts subfolder
    * `cd ../scripts && source env-vars.sh && cd ../monaco`

1. Run monaco with --dry-run option.  Ensure you get 'Validation finished without errors'.
    * `monaco deploy --project xmatters --environments=environment.yaml --dry-run`

1. Run monaco to deploy changes.  Ensure you get 'Validation finished without errors'.
    * `monaco deploy --project xmatters --environments=environment.yaml`

# First time monaco configuration file creation

These monaco configuration files were orginally built manually in the Dynatrace web-ui. Then the monaco CLI was run to download the files using the one-time downloadfeature. 

**_DO NOT run this again or it will likely error or overwrite the existing files, but here is what I did_**

1. Setup and run monaco
   * make the `environment.yaml`
   * ran `export NEW_CLI=1`
   * ran `monaco download --environments=environment.yaml`

1. Deleted any configuration folder(s) not required.  

1. Deleted any YAML configuration files not needed and updated the associated YAML configuration files to remove those YAML files configurations deleted.

1. Edit the configuration files to substitute values for IDs of other configurations
