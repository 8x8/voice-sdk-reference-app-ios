#!/bin/bash
BASE_DIR=`dirname $0`
pushd "$BASE_DIR"/../.. >/dev/null

WORKSPACE_ROOT_DIR=`pwd`

SWIFTLINT_CONFIG="$WORKSPACE_ROOT_DIR"/scripts/lint/swiftlint.yml

# check availability
if ! type swiftlint &>/dev/null; then
  echo "SwiftLint not installed, run 'brew install swiftlint' to install"
  echo "Skip swift lint phase for now."
  popd >/dev/null
  exit 0
fi

for path in ${1}
do
  # drop quotes
  path="${path%\"}"
  path="${path#\"}"

  echo "Swiftlint: ${path} …"
  swiftlint lint --config "$SWIFTLINT_CONFIG" --quiet "$WORKSPACE_ROOT_DIR"/$path
  if [ "$?" -ne "0" ]; then
    echo "ERROR: Failed to lint $path."
    popd >/dev/null
    exit 1
  fi
done

popd >/dev/null
