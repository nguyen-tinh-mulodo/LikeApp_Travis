#!/bin/sh
set -e
#xctool -project LikeApp.xcodeproj -scheme LikeApp build
xctool -project LikeApp.xcodeproj -scheme travis -sdk iphonesimulator  test
#

