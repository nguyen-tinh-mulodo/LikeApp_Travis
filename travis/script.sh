#!/bin/sh
set -e
xctool/xctool.sh -project LikeApp.xcodeproj -scheme travis build
xctool -project LikeApp.xcodeproj -scheme travis build test
#

