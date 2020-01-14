# aws_glacier_cookbook

## smallFile.sh

sh smallFile.sh vault_name file_name

## cancel.sh

sh cancel.sh vault_name file_name

## sendAll.sh

sh sendAll.sh vault_name \\*.file_extension

## multipart.sh

sh multipart.sh vault_name file_name

## deleteVault.sh

sh deleteVault.sh vault_name

## deleteArchive.sh

sh deleteArchive.sh vault_name file_name

## Downloading an archive

### step 1: initRetrievalJob.sh

sh initRetrievalJob.sh vault_name

get jobId from jobId.txt

### step 2: getJobOutput.sh

sh getJobOutput.sh vault_name job_id out_file_name

now you can see the archiveId's and their labels

### step 3: initArchiveRetrievalJob.sh

sh initArchiveRetrievalJob.sh vault_name

get jobId from jobId.txt

### step 4: getJobOutput.sh

sh getJobOutput.sh vault_name job_id out_file_name
