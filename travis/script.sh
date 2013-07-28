#!/bin/sh
set -e
xctool -project LikeApp.xcodeproj -scheme travis build test

