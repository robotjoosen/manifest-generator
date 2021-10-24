#!/usr/bin/env bash

ENV_FILE=.env

if ! test -f "$ENV_FILE"; then
    touch "$ENV_FILE"
fi

if ! grep -q "###> robotjosen/manifest-generator ###" "$ENV_FILE"; then
echo "###> robotjosen/manifest-generator ###
APP_NAME=
NAMESPACE=
HOST=
###< robotjosen/manifest-generator ###" >> "$ENV_FILE"
fi
