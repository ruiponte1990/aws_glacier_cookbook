#!/bin/bash
aws glacier initiate-job --account-id - --vault-name "${1}" --job-parameters '{"Type": "inventory-retrieval"}' | jq '.jobId' >> jobId.txt