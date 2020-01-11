rm output.txt
aws glacier upload-archive --account-id - --vault-name "${1}" --body "${2}" --archive-description "${2}" >>output.txt