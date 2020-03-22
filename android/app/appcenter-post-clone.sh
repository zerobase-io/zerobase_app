#!/usr/bin/env bash
# https://buildflutter.com/deploying-flutter-apps-via-appcenter/
# https://github.com/microsoft/appcenter/blob/master/sample-build-scripts/flutter/android-build/appcenter-post-clone.sh
# place this script in project/android/app/
cd ..
# fail if any command fails
set -e
# debug log
set -x

cd ..
# choose a different release channel if you want - https://github.com/flutter/flutter/wiki/Flutter-build-release-channels
# stable - recommended for production

git clone -b stable https://github.com/flutter/flutter.git
export PATH=`pwd`/flutter/bin:$PATH

flutter channel stable

# Make gradlew executable in AppCenter
chmod a+rx android/gradlew

flutter build apk --release

# copy the AAB where AppCenter will find it
mkdir -p android/app/build/outputs/apk/; mv build/app/outputs/apk/release/app-release.apk $_