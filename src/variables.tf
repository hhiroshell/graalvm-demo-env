/*
 * Copyright (c) 2019 Hiroshi Hayakawa <hhiroshell@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND
 */

# for OCI provider
variable "tenancy_ocid" {}
variable "compartment_ocid" {}
variable "region" {}
/* 
 * These variables are vomed to variables-for-local-exec.tf
 * to exclude when create a template archive for OCI Resource Manager.
 */
# variable "user_ocid" {}
# variable "fingerprint" {}
# variable "private_key_path" {}

data "oci_identity_availability_domains" "ads" {
    compartment_id = "${var.compartment_ocid}"
}

variable "core_instance_shape" {
    default = "VM.Standard.E2.1.Micro"
}