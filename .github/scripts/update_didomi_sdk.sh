#!/bin/bash

#----------------------------------------------------------
# Update iOS SDK version (latest from cocoapods)
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

lastVersion=$(pod_last_version)
if [[ -z $lastVersion ]]; then
  echo "Error while getting ios SDK version"
  exit 1
fi

echo "iOS SDK last version is $lastVersion"

sed -i~ -e "s|pod 'Didomi-XCFramework', '[0-9]\{1,2\}.[0-9]\{1,2\}.[0-9]\{1,2\}'|pod 'Didomi-XCFramework', '$lastVersion'|g" Podfile || exit 1

# Cleanup backup files
find . -type f -name '*~' -delete

pod update
