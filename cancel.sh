#!/bin/bash
aws glacier abort-multipart-upload --account-id - --vault-name "${1}" --upload-id "${2}"