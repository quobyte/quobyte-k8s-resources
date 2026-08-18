#!/usr/bin/env bash

if ! command -v oras &> /dev/null; then
  echo "Error: 'oras' is required but not installed."
  echo "Install oras using https://oras.land/docs/installation/"
  exit 1
fi

case "$1" in
  quobyte-csi|quobyte-client|quobyte-cluster) ;;
  *)
    echo "Error: chart must be one of: quobyte-csi, quobyte-client, quobyte-cluster."
    echo "Usage: $0 <chart>"
    exit 1
    ;;
esac

OCI_CHARTS="quay.io/quobyte/charts/$1"

printf "%-20s %-20s\n" "CHART VERSION" "APP VERSION"
echo "----------------------------------------"

for TAG in $(oras repo tags "$OCI_CHARTS"); do
  APP_VER=$(oras manifest fetch-config "$OCI_CHARTS:$TAG" 2>/dev/null | jq -r '.appVersion // "N/A"')
  printf "%s\t%s\n" "$TAG" "$APP_VER"
done | sort -t $'\t' -k2,2 -V -r | while IFS=$'\t' read -r TAG APP_VER; do
  printf "%-20s %-20s\n" "$TAG" "$APP_VER"
done