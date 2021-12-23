#!/bin/sh
set -e

# Environment variables are set by packer
/tmp/terraform-aws-nomad/modules/install-nomad/install-nomad --version "${NOMAD_VERSION}" --user "root"
/tmp/terraform-aws-nomad/modules/install-consul/install-consul --version "${CONSUL_VERSION}"
/tmp/terraform-aws-nomad/modules/install-cni-plugins/install-cni-plugins