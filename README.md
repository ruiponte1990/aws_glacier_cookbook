# aws_glacier_cookbook

## smallFile.sh

sh smallFile.sh vault_name file_name

## Canceling an upload

### step 1: listUploads.sh

sh listUploads.sh vault_name

get your uploadId from uploads.txt

### step 2: cancel.sh

sh cancel.sh vault_name upload_id

## sendAll.sh

sh sendAll.sh vault_name \\*.file_extension

## multipart.sh

sh multipart.sh vault_name file_name

## deleteVault.sh

sh deleteVault.sh vault_name

## Deleting an archive

### step 1: initRetrievalJob.sh

sh initRetrievalJob.sh vault_name

get jobId from jobId.txt

### step 2: getJobOutput.sh

sh getJobOutput.sh vault_name job_id out_file_name

now you can see the archiveId's and their labels

### step 3: getJobOutput.sh

### deleteArchive.sh

sh deleteArchive.sh vault_name archive_id

## Downloading an archive

### step 1: initRetrievalJob.sh

sh initRetrievalJob.sh vault_name

get jobId from jobId.txt

### step 2: getJobOutput.sh

sh getJobOutput.sh vault_name job_id out_file_name

now you can see the archiveId's and their labels

### step 3: initArchiveRetrievalJob.sh

sh initArchiveRetrievalJob.sh vault_name archive_id

get jobId from jobId.txt

### step 4: getJobOutput.sh

sh getJobOutput.sh vault_name job_id out_file_name
