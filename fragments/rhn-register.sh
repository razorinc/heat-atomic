#!/bin/bash

set -eu
set -o pipefail

if [ -n "$RHN_USERNAME" -a -n "$RHN_PASSWORD" ]; then
    subscription-manager register \
                         --username="$RHN_USERNAME" \
                         --password="$RHN_PASSWORD" \
                         --auto-attach
fi
