#!/bin/bash
VAULT="${1}"

aws glacier delete-vault --vault-name $VAULT --account-id -