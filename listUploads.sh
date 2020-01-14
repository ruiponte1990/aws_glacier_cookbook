#!/bin/bash
aws glacier list-multipart-uploads --account-id - --vault-name "${1}" >> uploads.txt