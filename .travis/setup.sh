#!/bin/bash

# Catch errors
set -e
set -o pipefail

# Fix the working directory
cd "${0%/*}"/../

# Setup the repo for deployment
git remote set-url origin $GITHUB_REPO
git config --global user.email "builds@travis-ci.com"
git config --global user.name "Travis CI"

# Assign the current Realm Object Server version
export REALM_VERSION=$(bash scripts/version.sh)

# Login to Docker Hub
docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"
