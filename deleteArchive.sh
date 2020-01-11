VAULT="${1}"
ARCHIVE="${2}"

aws glacier delete-archive --vault-name $VAULT --account-id - --archive-id $ARCHIVE