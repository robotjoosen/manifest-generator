#!/usr/bin/env bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
BASEDIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
TEMPLATE_FILE="$BASEDIR/../templates/deployment.yaml"

MANIFEST_DIR="deployment/manifests"
MANIFEST_FILE="$MANIFEST_DIR/deployment.yaml"

ENV_FILE=.env
export VERSION_TAG="$1"
export $(grep -v '^#' "$ENV_FILE" | xargs)

if ! test -f "$MANIFEST_DIR"; then
    mkdir -p $MANIFEST_DIR
fi

envsubst \$HOST,\$APP_NAME,\$NAMESPACE,\$VERSION_TAG < "$TEMPLATE_FILE" > "$MANIFEST_FILE"
