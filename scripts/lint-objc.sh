#!/bin/sh

set -eu

REPO_ROOT="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
DERIVED_DATA_PATH="${TMPDIR:-/tmp}/mrr-project-analyze"
LOG_PATH="$DERIVED_DATA_PATH/analyze.log"

if [ -z "${DEVELOPER_DIR:-}" ] && [ -d "/Applications/Xcode.app/Contents/Developer" ]; then
  export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"
fi

mkdir -p "$DERIVED_DATA_PATH"

if xcodebuild \
  -project "$REPO_ROOT/MRR Project.xcodeproj" \
  -scheme "MRR Project" \
  -sdk iphonesimulator \
  -configuration Debug \
  -derivedDataPath "$DERIVED_DATA_PATH" \
  CODE_SIGNING_ALLOWED=NO \
  analyze | tee "$LOG_PATH"; then
  if grep -q "The following commands produced analyzer issues:" "$LOG_PATH"; then
    echo "Static analyzer reported Objective-C issues." >&2
    exit 1
  fi

  echo "Objective-C lint completed without analyzer findings."
else
  exit 1
fi
