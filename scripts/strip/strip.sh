#!/bin/bash
BASE_DIR=`dirname $0`
pushd "$BASE_DIR"/../.. >/dev/null

WORKSPACE_ROOT_DIR=`pwd`
STRIP_TOOL="$WORKSPACE_ROOT_DIR"/scripts/strip/strip-frameworks.sh

"$STRIP_TOOL"
if [ "$?" -ne "0" ]; then
  echo "ERROR: Failed to strip frameworks."
  popd >/dev/null
  exit 1
fi

popd >/dev/null
