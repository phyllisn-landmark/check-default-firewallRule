#!/bin/bash

# Set your GCP project ID
project_list=$(gcloud projects list --format="value(projectId)") > projects #(this will query gcp and list all projects)
projects="./projects"
while IFS= read -r line
do
    echo "$line"
    PROJECT_ID="$line"    
    # Check for default RDP rule
    echo "Checking for default RDP rule..."
    RDP_RULE=$(gcloud compute firewall-rules list --project=${PROJECT_ID} --filter="name=default-allow-rdp" --format="value(name)")

    if [ -z "${RDP_RULE}" ]; then
        echo "Default RDP rule not found."
    else
        echo "Default RDP rule: ${RDP_RULE}"

        # List resources using the RDP rule
        echo "Resources using the default RDP rule:"
        gcloud compute instances list --project=${PROJECT_ID} --filter="tags.items=default-allow-rdp" --format="table[box](name,zone)"
    fi

    # Check for default SSH rule
    echo "Checking for default SSH rule..."
    SSH_RULE=$(gcloud compute firewall-rules list --project=${PROJECT_ID} --filter="name=default-allow-ssh" --format="value(name)")

    if [ -z "${SSH_RULE}" ]; then
        echo "Default SSH rule not found."
    else
        echo "Default SSH rule: ${SSH_RULE}"

        # List resources using the SSH rule
        echo "Resources using the default SSH rule:"
        gcloud compute instances list --project=${PROJECT_ID} --filter="tags.items=default-allow-ssh" --format="table[box](name,zone)"
    fi
    echo " "
done < "$projects"
