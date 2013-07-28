#!/bin/sh
set -e
xctool -project LikeApp.xcodeproj -scheme KIP build test

#xctool -workspace workspace.xcworkspace -scheme LikeApp build test
#MyWorkspace MyScheme
