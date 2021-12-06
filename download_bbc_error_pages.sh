#!/bin/sh

# This script downloads bbc-error-pages RPM to that it could be installed on CI
# before compiling Belfrage to make the error pages templates available during
# compilation.

set -e

curl -s \
  --cert /etc/pki/tls/certs/client_chain.crt \
  --key /etc/pki/tls/private/client.key \
  https://repository.api.bbci.co.uk/bbc-error-pages/revisions/head/packages \
  | tr -d '[]\"' \
  | xargs \
  curl -s -L --output bbc-error-pages.rpm \
  --cert /etc/pki/tls/certs/client_chain.crt \
  --key /etc/pki/tls/private/client.key
