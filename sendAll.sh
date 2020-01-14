#!/bin/bash
rm output.txt
files=$(find $1 -maxdepth 1 -type f)
echo $files
for file in $files
do
	ARCHIVE_SIZE=`cat "${file}" | wc --bytes`
	if [[ ${ARCHIVE_SIZE} -le 1048576 ]]
		archiveId=$(sh smallFile.sh "${2}" "${file}" | jq '.archiveId')
		echo "{ ${file} : ${archiveId} }" >> output.txt
	else
		sh multipart.sh "${2}" "${file}"
	fi
done