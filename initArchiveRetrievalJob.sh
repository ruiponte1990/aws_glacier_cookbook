#!/bin/bash
aws glacier initiate-job --account-id - --vault-name "${1}" --job-parameters '{"Type": "archive-retrieval", "ArchiveId": "${2}"}' | jq '.jobId' >> jobId.txt