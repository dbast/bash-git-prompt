#!/bin/bash

set -o errtrace -o nounset -o pipefail -o errexit

TEST_IMAGE_NAMES=${TEST_IMAGE_NAMES:-ubuntu:22.04 ubuntu:20.04 ubuntu:18.04 debian:bullseye debian:buster debian:bullseye debian:buster opensuse/leap registry.access.redhat.com/ubi9/ubi:9.1}

fail_count=0

for TEST_IMAGE_NAME in ${TEST_IMAGE_NAMES}; do
    echo "============= Test on ${TEST_IMAGE_NAME} ============="
    docker run --rm -v "$(pwd):/mnt" "${TEST_IMAGE_NAME}" /bin/bash -c " \
        set -eu pipefail; \
        command -v apt-get && apt-get update && apt-get install -y --no-install-recommends bash git || true; \
        command -v yum && yum install -y bash git || true; \
        command -v zypper && zypper install -y bash git || true; \
        hash -r; command -v bash git; \
        /mnt/tests/all-tests.sh" || ((fail_count++))
        echo "#### Current fail count: ${fail_count}."
done

exit ${fail_count}
