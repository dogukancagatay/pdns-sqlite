#!/usr/bin/env bash

IMAGE_NAME="dcagatay/pdns-sqlite"
IMAGE_TAG="4.4.1"

set -x

docker buildx bake --set="app-a*.args.BUILD_DATE=`date -u +'%Y-%m-%dT%H:%M:%SZ'`"

docker push "$IMAGE_NAME:$IMAGE_TAG"_amd64
docker push "$IMAGE_NAME:$IMAGE_TAG"_armv7
docker push "$IMAGE_NAME:latest"_amd64
docker push "$IMAGE_NAME:latest"_armv7

docker manifest create "$IMAGE_NAME:$IMAGE_TAG" "$IMAGE_NAME:$IMAGE_TAG"_amd64 "$IMAGE_NAME:$IMAGE_TAG"_armv7
docker manifest create "$IMAGE_NAME:latest" "$IMAGE_NAME:latest"_amd64 "$IMAGE_NAME:latest"_armv7

docker manifest push "$IMAGE_NAME:$IMAGE_TAG"
docker manifest push "$IMAGE_NAME:latest"
