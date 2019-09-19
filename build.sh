#/bin/sh

# Copyright (c) 2019 Hiroshi Hayakawa <hhiroshell@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND

# -------------------------------------------------------------------
# This script creates a template archive for the OCI Resouce Manager.
# About the OCI RM, see the documentation below:
#     https://docs.cloud.oracle.com/iaas/Content/ResourceManager/Concepts/resourcemanager.htm
# -------------------------------------------------------------------

cd `dirname $0`

# valiables
export ARTIFACT_NAME=oci-sandbox

# clean up
rm -rf target

# build
mkdir target
cd src
zip --verbose \
    --recurse-paths \
    ../target/${ARTIFACT_NAME} * \
    --exclude=./terraform.tfstate* \
    --exclude=./terraform.tfvars* \
    --exclude=./provider.tf \
    --exclude=./variables-for-local-exec.tf