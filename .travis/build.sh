#!/bin/bash

# Catch errors
set -e

# Fix the working directory
cd "${0%/*}"/../

# Build the Docker image
bash scripts/docker_build_force.sh
