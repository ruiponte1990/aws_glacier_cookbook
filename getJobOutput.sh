#!/bin/bash
aws glacier get-job-output --account-id - --vault-name "${1}" --job-id "${2}" >> "${3}""