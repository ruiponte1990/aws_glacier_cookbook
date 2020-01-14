#!/bin/bash

byteSize=4194304
CHUNK_SIZE=4194304
hashsize=1048576

if [[ -z "${1}" ]]; then
	echo "No vault provided."
	exit 1
fi

if [[ -z "${2}" ]]; then
	echo "No file provided."
	exit 1
fi

ARCHIVE="${2}"
ARCHIVE_SIZE=`cat "${ARCHIVE}" | wc -- bytes`
VAULT="${1}"

rm -rf TEMP

rm -rf HASH

mkdir TEMP

mkdir HASH

cd TEMP

split -d --bytes=${CHUNK_SIZE} "../${ARCHIVE}" chunk -a 4

cd ../HASH

split -d --bytes=${hashsize} "../${ARCHIVE}" chunk -a 5

cd ../TEMP

lastpartsize=`expr $(ls -l | tail -1 | awk '{print$6}') + 0`

echo "lastpartsize: ${lastpartsize}"

lastfile=$(ls -l | tail -1 | awk '{print$10}')

echo "lastfile : ${lastfile}"

cont=$(ls -l | wc -l)

cnt=`expr $cont -2`

fileCount=$(ls -1 | grep "^chunk" | wc -l)

echo "Total parts to upload: " $fileCount

files=$(ls | grep "^chunk")

init=$(aws glacier initiate-multipart-upload --account-id - --part-size $byteSize --vault-name "${VAULT}" --archive-description "${ARCHIVE}_${ARCHIVE_SIZE}_${byteSize}")

uploadId=$(echo $init | jq '.uploadId' | xargs)

touch commands.txt

i=0
for f in $files
	do
		byteStart=$((i*byteSize))
		byteEnd=$((i*byteSize+byteSize-1))
		echo aws glacier upload-multipart --body $f --range "'"'bytes '"$byteStart"'-'"$byteEnd"'/*'"'" --account-id - --vault-name "${VAULT}" --upload-id $uploadId >> commands.txt
		i=$(($i+1))

		if [ "$i" == "$cnt" ]; then
			byteEnd=`expr $byteEnd +1`
			byteEnd2=$((i*byteSize+lastpartsize-1))
			byteSize=$lastpartsize
			echo aws glacier upload-multipart --body $lastfile --range "'"'bytes '"$byteEnd"'-'"$byteEnd2"'/*'"'" --account-id - --vault-name "${VAULT}" --upload-id $uploadId >> commands.txt
			break
		fi
	done

parallel --load 100% -a commands.txt --no-notice --bar

cd ../HASH

files=$(ls | grep "^chunk")

for f in $files
	do
		openssl dgst -sha256 -binary ${f} > "hash${f:5}"
	done

echo "List Active Multipart Uploads:"

aws glacier list-multipart-uploads --account-id - --vault-name "${VAULT}" >> ../TEMP/commands.txt

echo "Calculating tree hash..."

while true; do
	COUNT=`ls hash* | wc -l`
	if [[ ${COUNT} -le 2 ]]; then
		TREE_HASH=$(cat hash* | openssl dgst -sha256 | awk '{print $2}')
		break
	fi
	ls hash* | xargs -n 2 | while read PAIR; do
		PAIRARRAY=(${PAIR})
		if [[ ${#PAIRARRAY}[@]} -eq 1 ]]; then
			break
		fi
		cat ${PAIR} | openssl dgst sha256 -binary > temphash
		rm ${PAIR}
		mv temphash "${PAIRARRAY[0]}"
	done
done

cd ../TEMP

archiveId=$(aws glacier complete-multipart-upload --account-id=- --vault-name="${VAULT}" --upload-id="$uploadId" --checksum="${TREE_HASH}" --archive-size=${ARCHIVE_SIZE} | jq '.archiveId')

echo "{ ${ARCHIVE} : ${archiveId} }" >> ../output.txt

RETVAL=$?

if [[ ${RETVAL} -ne 0 ]]; then
	echo "complete-multipart-upload failed with code: ${RETVAL}" >> commands.txt
	echo "Aborting upload ${uploadId}" >> commands.txt
	aws glacier abort-multipart-upload --account-id=- --vault-name="${VAULT}" --upload-id="${uploadId}" >> commands.txt
	exit 1
fi

echo "Done."
exit 0

