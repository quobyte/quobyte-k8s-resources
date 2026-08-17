#!/usr/bin/env bash

set -euo pipefail

usage() {
    echo "Usage: $0 <chart_dir> <chart_version> <app_version> [quay_helm_url] [quay_username] [csi_container_url_base]"
    echo "       $0 --package <chart_package.tgz> [quay_helm_url] [quay_username]"
    echo "Example: $0 ./quobyte-csi 1.2.3 v2.1.0"
    echo "Example: $0 --package ./quobyte-csi-1.2.3.tgz"
}

if ! command -v helm &> /dev/null; then
    echo "Error: 'helm' is required but not installed."
    exit 1
fi

if [[ "${1:-}" == "--package" || "${1:-}" == "-p" ]]; then
    if [ "$#" -lt 2 ]; then
        echo "Error: Missing package path."
        usage
        exit 1
    fi

    PACKAGE_PATH=$2
    QUAY_HELM_URL=${3:-"quay.io/quobyte/helm/"}
    QUAY_USERNAME=${4:-"quobyte"}

    if [ ! -f "${PACKAGE_PATH}" ]; then
        echo "Error: Package file '${PACKAGE_PATH}' not found."
        exit 1
    fi

    echo "=== Authenticating with Quay.io ==="
    helm registry login quay.io -u "${QUAY_USERNAME}"

    echo "=== Pushing existing package ${PACKAGE_PATH} to Quay.io OCI Registry ==="
    helm push "${PACKAGE_PATH}" "oci://${QUAY_HELM_URL}"
    echo "=== Success! Chart pushed to oci://${QUAY_HELM_URL} ==="
    exit 0
fi

if [ "$#" -lt 3 ]; then
    echo "Error: Missing arguments."
    usage
    exit 1
fi

CHART_DIR=$1
CHART_VERSION=$2
APP_VERSION=$3
QUAY_HELM_URL=${4:-"quay.io/quobyte/helm/"}
QUAY_USERNAME=${5:-"quobyte"}
CSI_CONTAINER_URL_BASE=${6:-"quay.io/quobyte/csi"}

if [[ ! "${APP_VERSION}" =~ ^v ]]; then
    echo "Error: App version must start with a lowercase 'v' (e.g., v1.2.3, v2.5.0)."
    echo "You provided: '${APP_VERSION}'"
    exit 1
fi

if ! command -v git &> /dev/null; then
    echo "Error: 'git' is required but not installed."
    exit 1
fi

if ! git rev-parse --is-inside-work-tree &> /dev/null; then
    echo "Error: The target directory is not inside a Git repository."
    exit 1
fi

echo "=== Authenticating with Quay.io ==="
helm registry login quay.io -u "${QUAY_USERNAME}"

echo "=== Linting chart in ${CHART_DIR} ==="
helm lint "${CHART_DIR}"

echo "=== Updating Chart.yaml with version: ${CHART_VERSION} and appVersion: ${APP_VERSION} ==="
TEMP_FILE=$(mktemp)
sed -e "s/^version:.*/version: ${CHART_VERSION}/" \
    -e "s/^appVersion:.*/appVersion: \"${APP_VERSION}\"/" \
    "${CHART_DIR}/Chart.yaml" > "${TEMP_FILE}"
mv "${TEMP_FILE}" "${CHART_DIR}/Chart.yaml"

update_csi_files_with_version(){
  sed -i "s|.*csiProvisionerVersion:.*|    csiProvisionerVersion: \"${APP_VERSION}\"|g" \
  "${CHART_DIR}/values.yaml"
  sed -i "s|.*csiImage:.*|    csiImage: \"${CSI_CONTAINER_URL_BASE}:${APP_VERSION}\"|g" \
  "${CHART_DIR}/values.yaml"
  sed -i "s|- --driver_version=.*|- --driver_version=${APP_VERSION}|g" \
  "${CHART_DIR}/tests/__snapshot__/csi_driver_test.yaml.snap"
  sed -i "s|image: quay.io/quobyte/csi:.*|image: ${CSI_CONTAINER_URL_BASE}:${APP_VERSION}|g" \
  "${CHART_DIR}/tests/__snapshot__/csi_driver_test.yaml.snap"
}

if [[ "${CHART_DIR}" =~ *-csi ]]; then
  update_csi_files_with_version
fi

echo "=== Packaging Helm Chart ==="
# Capture the output to extract the exact filename generated
PACKAGE_OUTPUT=$(helm package "${CHART_DIR}")
echo "${PACKAGE_OUTPUT}"
PACKAGE_PATH=$(echo "${PACKAGE_OUTPUT}" | awk -F': ' '{print $2}')

echo "=== Pushing to Quay.io OCI Registry ==="
helm push "${PACKAGE_PATH}" "oci://${QUAY_HELM_URL}"
if [[ $1 -ne 0 ]]; then
  echo "FAILURE: push to oci://${QUAY_HELM_URL} failed."
fi
rm "${PACKAGE_PATH}"
echo "=== Success! Chart pushed to oci://${QUAY_HELM_URL} ==="

git add "${CHART_DIR}/Chart.yaml"
git commit -m "Updated by ${0} for chart ${CHART_DIR}"

CHART_NAME=$(basename "${CHART_DIR}")
TAG_NAME="${CHART_NAME}-${CHART_VERSION}"
echo "=== Creating git tag ${TAG_NAME} ==="
git tag -a "${TAG_NAME}" -m "Release ${CHART_NAME} chart version ${CHART_VERSION} (appVersion ${APP_VERSION})"

echo "=== Pushing commit and tag to origin ==="
git push origin HEAD
git push origin "${TAG_NAME}"
echo "=== Tag ${TAG_NAME} pushed. ==="
