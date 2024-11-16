# Use Ubuntu as the base image
FROM ubuntu:22.04

ENV S3_BUCKET_NAME=bogusbucket
ENV CLOUDFRONT_ID=boguscloudfrontkey
ENV AWS_ACCESS_KEY_ID=bogusaccesskey
ENV AWS_SECRET_ACCESS_KEY=bogussecret
ENV AWS_SESSION_TOKEN=bogustoken
ENV AWS_REGION=us-west-2

RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    hugo

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip


COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]