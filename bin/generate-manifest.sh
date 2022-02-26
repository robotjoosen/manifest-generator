#!/usr/bin/env bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
BASEDIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

if [[ -d "deployment/templates" ]]
then
  TEMPLATE_DIR="deployment/templates"
else
  TEMPLATE_DIR="$BASEDIR/../templates"
fi

MANIFEST_DIR="deployment/manifests"

ENV_FILE=.env
export VERSION_TAG="$1"
export $(grep -v '^#' "$ENV_FILE" | xargs)

for FILE in `find $TEMPLATE_DIR/* -type f`
do
  NEW_PATH=$FILE | sed  "s/${TEMPLATE_DIR//\//\\/}//"
  NEW_MANIFEST_FILE="${FILE/$TEMPLATE_DIR/$MANIFEST_DIR$NEW_PATH}"

  mkdir -p `dirname $NEW_MANIFEST_FILE` && \
  envsubst \$HOST,\$APP_NAME,\$NAMESPACE,\$VERSION_TAG < "$FILE" > "$NEW_MANIFEST_FILE"
done
