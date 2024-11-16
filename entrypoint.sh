#!/bin/bash
# Exit immediately if a command exits with a non-zero status
set -e

# Replace this file and run your AWS commands here
echo "S3 deployment is starting."

# Define the folder path
FOLDER_PATH="/app/hugo"
PUBLIC_PATH="/app/hugo/public"

# Check if the folder exists
if [ ! -d "$FOLDER_PATH" ]; then
    echo "Error: Folder '$FOLDER_PATH' does not exist. Exiting....."
    exit 1
fi

# Build the Hugo site
echo "Building the Hugo site."
hugo_command_output=$(hugo --source $FOLDER_PATH)
hugo_command_exit_code=$?


# If we reach here, the folder exists
echo "Uploading $FOLDER_PATH to $S3_BUCKET_NAME."

s3_command_output=$(aws s3 sync $PUBLIC_PATH s3://$S3_BUCKET_NAME --delete)
s3_command_exit_code=$?

# check if the command failed
if [[ "$s3_command_exit_code" -ne 0 ]]; then
    echo "An error occurred syncing with the S3 bucket: $s3_command_output"
    exit 1
else
    echo "S3 uploading completed!"
fi

# Refresh the CloudFront cache
echo "Creating an invalidation for CloudFront ID $CLOUDFRONT_ID."

cloudfront_command_output=$(aws cloudfront create-invalidation --distribution-id $CLOUDFRONT_ID --paths '/*')
cloudfront_command_exit_code=$?

# check if the command failed
if [[ "$cloudfront_command_exit_code" -ne 0 ]]; then
    echo "An error occurred when creating a CloudFront Invalidation: $cloudfront_command_output"
    exit 1
else
    echo "CloudFront Invalidation created successfully!"
fi

exit 0