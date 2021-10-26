#!/bin/bash

mkdir $DEPLOY_DIRECTORY

set -o pipefail &&
  env NSUnbufferedIO=YES \
  xcodebuild \
    -workspace "$XCODEBUILD_WORKSPACE" \
    -scheme "$XCODEBUILD_SCHEME" \
    -destination "$1" \
    -resultBundlePath "./deploy/Test.xcresult" \
    -enableCodeCoverage YES \
    clean test \
  | tee "./deploy/xcodebuild.log" \
  | xcpretty
