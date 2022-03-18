#!/bin/sh
ENVSUBST_CMD="${ENVSUBST_CMD:-/usr/bin/envsubst}"
TROJAN_CMD="${TROJAN_CMD:-/usr/bin/trojan}"
TROJAN_CONFIG="${TROJAN_CONFIG:-/config/config.json}"
TROJAN_CONFIG_TEMPLATE="${TROJAN_CONFIG_TEMPLATE:-/config/config.json.template}"
TROJAN_CONFIG_DEFAULT_ENV="${TROJAN_CONFIG_DEFAULT_ENV:-/config/.default_env}"

source "${TROJAN_CONFIG_DEFAULT_ENV}"

${ENVSUBST_CMD} < ${TROJAN_CONFIG_TEMPLATE} > ${TROJAN_CONFIG}

exec ${TROJAN_CMD} $@
