#!/bin/sh
ENVSUBST_CMD="${ENVSUBST_CMD:-/usr/bin/envsubst}"
ENVSUBST_ENABLED="${ENVSUBST_ENABLED:-false}"
TROJAN_CMD="${TROJAN_CMD:-/usr/bin/trojan}"
TROJAN_CONFIG="${TROJAN_CONFIG:-/config/config.json}"
TROJAN_CONFIG_TEMPLATE="${TROJAN_CONFIG_TEMPLATE:-/config/template/config.json.template}"
TROJAN_CONFIG_DEFAULT_ENV="${TROJAN_CONFIG_DEFAULT_ENV:-/config/template/.default_env}"

if [[ ${ENVSUBST_ENABLED} == "true" ]]; then
    source "${TROJAN_CONFIG_DEFAULT_ENV}"
    ${ENVSUBST_CMD} < ${TROJAN_CONFIG_TEMPLATE} > ${TROJAN_CONFIG}
fi

exec ${TROJAN_CMD} $@
