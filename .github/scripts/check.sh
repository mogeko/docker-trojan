#!/usr/bin/env bash

API_STATUS_META=${API_STATUS_META:-"https://mogeko.github.io/docker-trojan/index.json"}
API_REPO_TAGS=${API_REPO_TAGS:-"https://api.github.com/repos/trojan-gfw/trojan/tags"}
API_REPO_REFS=${API_REPO_REFS:-"https://api.github.com/repos/trojan-gfw/trojan/git/refs"}

export STATUS_TROJAN_VER=$(curl -s "${API_STATUS_META}" | jq -r '.trojan_ver')
export STATUS_EDGE_SHA=$(curl -s "${API_STATUS_META}" | jq -r '.edge.sha')
export STATUS_LATEST_SHA=$(curl -s "${API_STATUS_META}" | jq -r '.latest.sha')
export STATUS_DOCKFILE_SHA=$(curl -s "${API_STATUS_META}" | jq -r '.dockerfile.sha')
export PKG_REL=2
export TROJAN_VER=$(curl -s "${API_REPO_TAGS}" | jq -r '.[0].name')
export EDGE_SHA=$(curl -s "${API_REPO_REFS}/heads/master" | jq -r '.object.sha')
export LATEST_SHA=$(curl -s "${API_REPO_REFS}/tags/${TROJAN_VER}" | jq -r '.object.sha')
export DOCKERFILE_SHA=$(shasum "${GITHUB_WORKSPACE:-.}/Dockerfile" | awk '{print $1}')
export TIMESTAMP_UTC=$(date -u "+%Y-%m-%dT%H:%M:%SZ")

envsubst < ./public/index.json.template > ./public/index.json
rm -rf ./public/index.json.template

if [[ ! "${STATUS_DOCKFILE_SHA}" =~ "${DOCKERFILE_SHA}" ]]; then
  export PKG_REL=$((PKG_REL + 1))
  unset STATUS_LATEST_SHA
fi

if [[ ! ${STATUS_EDGE_SHA} =~ ${EDGE_SHA} ]]; then
  echo "::set-output name=is_new::yes"
  echo "::set-output name=edge::type=edge"
  echo "::set-output name=edge_sha::type=raw,${EDGE_SHA:0:7}"
  echo "::set-output name=trojan_ver::master"
fi

if [[ ! ${STATUS_LATEST_SHA} =~ ${LATEST_SHA} ]]; then
  echo "::set-output name=is_new::yes"
  echo "::set-output name=latest::type=raw,latest"
  echo "::set-output name=img_ver::type=raw,${TROJAN_VER#v}-r${PKG_REL}"
  echo "::set-output name=latest_sha::type=raw,${LATEST_SHA:0:7}"
  echo "::set-output name=trojan_ver::${TROJAN_VER}"
fi

if [[ ! ${STATUS_TROJAN_VER} =~ ${TROJAN_VER} ]]; then
  echo "::set-output name=img_ver::type=raw,${TROJAN_VER#v}-r1"
fi
