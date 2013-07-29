#!/bin/sh
set -e
xctool -project LikeApp.xcodeproj -scheme LikeApp -sdk iphonesimulator  build
xctool -project LikeApp.xcodeproj -scheme travis -sdk iphonesimulator  test
#

