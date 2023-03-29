#!/bin/bash

#----------------------------------------------------------
# Check iOS SDK version (latest from cocoapods)
#----------------------------------------------------------

# Get last version from pod
pod_last_version() {
  lastVersion=""
  for line in $(pod trunk info Didomi-XCFramework); do
    if [[ "$line" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
      lastVersion=$line
    fi
  done
  echo "$lastVersion"
}

currentVersion=$(sh .github/scripts/extract_ios_sdk_version.sh)
if [[ -z $currentVersion ]]; then
  echo "Error while getting ios SDK current version"
  exit 1
fi

lastVersion=$(pod_last_version)
if [[ -z $lastVersion ]]; then
  echo "Error while getting ios SDK version"
  exit 1
fi

if [[ "$currentVersion" == "$lastVersion" ]]; then
  echo "iOS SDK last version is $currentVersion, no change"
  exit 0
fi

# Confirm update
echo "yes"
