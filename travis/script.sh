#!/bin/sh
set -e
xctool -project LikeApp.xcodeproj -scheme travis build test

#
#xctool -workspace workspace.xcworkspace -scheme LikeApp build test
#MyWorkspace MyScheme
