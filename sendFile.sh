ARCHIVE="${2}"
ARCHIVE_SIZE=`cat "${ARCHIVE}" | wc --bytes`

if [[${ARCHIVE_SIZE} -le 104875]]; then
	echo aws glacier upload-archive --account-id - --vault-name "${1}" --body "${2}" --archive-description "${2}"
else
	echo sh multipart.sh "${1}" "${2}"
fi