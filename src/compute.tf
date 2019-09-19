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

locals {
    instance-image-ocid = {
        // See https://docs.us-phoenix-1.oraclecloud.com/images/
        // Oracle-provided image "Oracle-Linux-6.10-2019.08.02-0"
        ap-mumbai-1    = "ocid1.image.oc1.ap-mumbai-1.aaaaaaaaybpzvkffzhicx4xuzdurudpdbdbbphdqx67deavscr5m6uggduka"
        ap-seoul-1     = "ocid1.image.oc1.ap-seoul-1.aaaaaaaa55voegjunt6ctz2p2zqcmml6qcsrd3s4hspgn2imxfgohh5opika"
        ap-sydney-1    = "ocid1.image.oc1.ap-sydney-1.aaaaaaaabwxzzflvakkwkp72qchxuubu7vg6fm3ew3qtjd67vge7c7lr2spq"
        ap-tokyo-1     = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaau4wlvvida2gedfvz7cvvqhentwrcibnlwceinslag4bbe3zehuzq"
        ca-toronto-1   = "ocid1.image.oc1.ca-toronto-1.aaaaaaaawh6ahlxoqpfuap3eshonlw5caopadhgroqy6h3hh5gkujmhescrq"
        eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa2c2cncycdx7h6vvnmcwkbvduxxbq3hog5vq3pt56wisfzvo5v4fq"
        eu-zurich-1    = "ocid1.image.oc1.eu-zurich-1.aaaaaaaa2d26py4ywrk3bgxhkdssetci2hbckoct6tljnnu7ze6cy75fqeyq"
        sa-saopaulo-1  = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaaqxng2vv7p7nkxj3zmjafwjqeovlastvvil7bpagvjsi2ohxse6aa"
        uk-london-1    = "ocid1.image.oc1.uk-london-1.aaaaaaaasvz6lgwp2h447q2xbmgpd6k2643hejdezzihlafevfqkmtrvd3ia"
        us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaartvky7t5lic2re6qfbgvxecsq4hndqtrhekznqq57fl2w4kats5a"
        us-langley-1   = "ocid1.image.oc2.us-langley-1.aaaaaaaatae44ndpmqetnxjgjdn7asryrpoafmd5cvvapsm6gqmtlyxulsrq"
        us-luke-1      = "ocid1.image.oc2.us-luke-1.aaaaaaaaagnmogcg4hjmitqmj7g2shebhkfvxecfmmrmuove7kxrcrveqlla"
        us-phoenix-1   = "ocid1.image.oc1.phx.aaaaaaaanv6huwyz46vt7szefoic4dq34tps5vhhypnfaskqqfv3rfakwtba"
    }
}

resource "tls_private_key" "sandbox-ssh-key-pair" {
    algorithm = "RSA"
}

resource "oci_core_instance" "sandbox" {
    display_name        = "sandbox"
    compartment_id      = "${var.compartment_ocid}"
    availability_domain = "${lookup(data.oci_identity_availability_domains.ads.availability_domains[0], "name")}"
    shape               = "${var.core_instance_shape}"
    create_vnic_details {
        display_name     = "primary-vnic"
        subnet_id        = "${oci_core_subnet.sandbox-sn-ad1.id}"
        assign_public_ip = true
    }

    source_details {
        source_type = "image"
        source_id   = "${local.instance-image-ocid["${var.region}"]}"
    }

    extended_metadata = {
        ssh_authorized_keys = "${tls_private_key.sandbox-ssh-key-pair.public_key_openssh}"
    }

    connection {
        type        = "ssh"
        host        = "${self.public_ip}"
        user        = "opc"
        private_key = "${tls_private_key.sandbox-ssh-key-pair.private_key_pem}"
    }
}

output "sandbox-public-ip" {
    value = ["${oci_core_instance.sandbox.public_ip}"]
}

output "sandbox-private-key-pem" {
    value = ["${tls_private_key.sandbox-ssh-key-pair.private_key_pem}"]
}